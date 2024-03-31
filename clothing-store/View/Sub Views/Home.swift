//
//  Home.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-29.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct Home: View {
    @Namespace var animation
    @StateObject var sharedData = SharedProductViewModel()
    @StateObject var homeVM = HomeViewModel()
    @State private var selectedCategory: String = "All" // Initially "All"
    @State private var selectedTypes: String = "All" // Initially "All"
    @Environment(\.presentationMode) var present
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15, content: {
                HStack(spacing: 20){
                    Button(action: {
                        if Auth.auth().currentUser != nil {
                            withAnimation {
                                sharedData.showProfilePage = true
                            }
                        }else {
                            withAnimation(.easeOut){
                                present.wrappedValue.dismiss()
                            }
                        }


                    }, label: {
                        Image("Profile")
                            .font(.title)
                            .foregroundColor(Color.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        
                        if let currentUser = Auth.auth().currentUser {
                            withAnimation {
                                sharedData.showWishListPage = true
                            }
                        }else {
                            withAnimation(.easeOut){
                                present.wrappedValue.dismiss()
                            }
                        }
 
                    }, label: {
                        Image("Liked")
                            .font(.title2)
                    })
                    Button(action: {
                        
                        if let currentUser = Auth.auth().currentUser {
                            withAnimation {
                                sharedData.showCartPage = true
                            }
                        }else {
                            withAnimation(.easeOut){
                                present.wrappedValue.dismiss()
                            }
                        }

                    }, label: {
                        Image("CartNew")
                            .font(.title2)
                    })
                    
                }
                .padding([.horizontal], 20)
                
                ZStack{
                    if homeVM.searchActivated {
                        SearchBar()
                    }else {
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCH", in: animation)
                    }
                }
                .frame(width: getRect().width / 1.2 )
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        homeVM.searchActivated = true
                    }
                }
                
                Text("Types")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                    .padding(.bottom,5)
                // Top Category List
                ScrollView(.horizontal, showsIndicators: false){
                    if !homeVM.uniqueTypes.isEmpty {
                        HStack(spacing: 18, content: {
                            // Product Categories
                            ForEach(homeVM.uniqueTypes.sorted(), id:  \.self){type in
                                Button {
                                    withAnimation {
                                        selectedTypes = type
                                        homeVM.filterByTypes(type: selectedTypes)
                                    }
                                } label: {
                                    Text(type.capitalized)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedTypes == type ? Color("BG") : Color("FBlack"))
                                        .padding(.vertical, 10)
                                        
                                }
                                .padding(.horizontal, 15)
                                .background(
                                    Capsule()
                                        .foregroundColor(selectedTypes == type ? Color("FPurple") : Color("BG"))
                                )

                            }
                            
                        })
                        .padding(.horizontal,25)
                    } else {
                        ProgressView()
                            .padding(.leading, 25)
                        }
                    }.padding(.top,5)
                
                Text("Categories")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                    .padding(.bottom,5)
                // Top Category List
                ScrollView(.horizontal, showsIndicators: false){
                    if !homeVM.uniqueCategories.isEmpty {
                        HStack(spacing: 18, content: {
                            // Product Categories
                            ForEach(homeVM.uniqueCategories.sorted(), id:  \.self){category in
                                Button {
                                    withAnimation {
                                        selectedCategory = category
                                        homeVM.filterByCategory(category: selectedCategory)
                                    }
                                } label: {
                                    Text(category.capitalized)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedCategory == category ? Color("BG") : Color("FBlack"))
                                        .padding(.vertical, 10)
                                        
                                }
                                .padding(.horizontal, 15)
                                .background(
                                    Capsule()
                                        .foregroundColor(selectedCategory == category ? Color("FPurple") : Color("BG"))
                                )

                            }
                            
                        })
                        .padding(.horizontal,25)
                    } else {
                        ProgressView()
                            .padding(.leading, 25)
                        }
                    }.padding(.top,5)
                
                HStack(spacing: 25, content: {
                    Text("Popular Products")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(width: getRect().width / 2, alignment: .leading)
                        .padding(.horizontal, 25)
                    
                    Button(action: {
                    }, label: {
                        Text("View All")
                            .font(.system(size: 14))
                            .foregroundColor(Color("FPurple"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 25)
                    })
                    

                })
                .padding(.top,15)
                

                //Product Page
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 25), GridItem(.flexible(), spacing: 25)], spacing: 25) {
                        if !homeVM.products.isEmpty {
                            ForEach(homeVM.filterProducts) { product in
                                ProductCardView(product: product)
                            }
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                // Show loading indicator while data is being fetched
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 10)
            })
            .padding(.vertical)

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("WhiteBG"))
        .onAppear {
            homeVM.fetchData()
        }
        .overlay {
            ZStack{
                if homeVM.searchActivated{
                    SearchView(animation: animation)
                        .environmentObject(homeVM)
                        .environmentObject(sharedData)
                }
                
                if let product = sharedData.detailProduct,sharedData.showDetails{
                    Productdetails(animation: animation, product: product)
                        .environmentObject(sharedData)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
                
                if sharedData.showCartPage {
                    Cart()
                        .environmentObject(sharedData)
                }
                
                if sharedData.showWishListPage {
                    Wishlist()
                        .environmentObject(sharedData)
                }
                
                if sharedData.showProfilePage {
                    Profile()
                        .environmentObject(sharedData)
                }
            }
        }
        .navigationBarHidden(true)
        
    }
    
    @ViewBuilder
    func SearchBar()-> some View {
        HStack(spacing: 15, content: {
            Image("Search")
                .font(.title2)
                .foregroundColor(.gray)
            TextField("Search", text: .constant(""))
                .disabled(true)
        })
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(
            Color("BG").cornerRadius(25)
                
        )

        
    }
    
    @ViewBuilder
    func ProductCardView(product: Product)-> some View{
        VStack(spacing: 10, content: {
            ZStack{
                if sharedData.showDetails{
                    WebImage(url: URL(string: product.imageURL))
                        .resizable()
                        .indicator(.activity) // Activity indicator while loading
                        .scaledToFit() // Scale the image to fit the frame
                        .opacity(0)
                }else {
                    WebImage(url: URL(string: product.imageURL))
                        .resizable()
                        .indicator(.activity) // Activity indicator while loading
                        .scaledToFit() // Scale the image to fit the frame
                        .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                }
            }
            .frame(width: getRect().width / 4, height: getRect().height / 5) // Set desired frame size
            Text(product.name)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .frame(maxWidth: getRect().width / 3, alignment: .leading)
                .multilineTextAlignment(.center) // Adjust alignment as needed
                .lineLimit(4) // Allow unlimited lines
            
            Text(product.category.capitalized)
                .font(.system(size: 14))
                .frame(maxWidth: getRect().width / 3, alignment: .leading)
                .foregroundColor(.gray)
            
            Text("Rs. "+String(format: "%.2f", product.price))
                .font(.system(size: 18))
                .fontWeight(.bold)
                .frame(maxWidth: getRect().width / 3, alignment: .leading)
                .foregroundColor(Color("FPurple"))
        })
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
        .background(
            Color("BG").cornerRadius(25)
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.detailProduct = product
                sharedData.showDetails = true
            }
        }
    }
}

#Preview {
    Home()
}
