//
//  SearchView.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    @EnvironmentObject var homeVM: HomeViewModel
    @FocusState var startTF: Bool
    
    @EnvironmentObject var sharedData: SharedProductViewModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 20){
                Button(action: {
                    withAnimation {
                        homeVM.searchActivated = false
                    }
                    homeVM.searchText = ""
                    sharedData.showSearchPage = false
                }, label: {
                    Image("Back")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }).padding(.top, 20)
                
                HStack(spacing: 15, content: {
                    Image("Search")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search", text: $homeVM.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                })
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .stroke(Color("FPurple"), lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.top)
            }
            .padding([.horizontal])
        
            if let products = homeVM.searchProducts {
                if products.isEmpty {
                    VStack(spacing: 0){
                        Image("searchBG")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: getRect().width / 3, height: getRect().height / 3)
                            .padding(.top, 60)
                        
                        Text("Sorry, we couldn't find any matching result for your Search.")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 0){
                            Text("\(products.count) Results Found")
                                .font(.system(size: 14))
                                .padding(.vertical)
                                .padding(.leading, 25)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
//                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                                    if !products.isEmpty {
                                        ForEach(products) { product in
                                            ProductCardView(product: product)
                                                .padding(5)
                                        }
                                    } else {
                                        ProgressView()
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            // Show loading indicator while data is being fetched
                                    }
                                }
                                .padding(.horizontal, 25)
//                            }
//                            .padding(.top, 10)
                        }
                       

                    }.padding(.horizontal)
                        .padding(.top)
                }
            }else {
                ProgressView()
                    .padding(.top, 30)
                    .opacity(homeVM.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color("BG")
                .ignoresSafeArea()
        )
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                startTF = true
            }
        }
        
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
                        .matchedGeometryEffect(id: "\(product.id)SEARCH", in: animation)
                }
            }
            .frame(width: getRect().width / 4, height: getRect().height / 5) // Set desired frame size
            
            Text(product.name)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .frame(maxWidth: getRect().width / 3, alignment: .center)
                .multilineTextAlignment(.center) // Adjust alignment as needed
                .lineLimit(4) // Allow unlimited lines
            
            Text(product.category.capitalized)
                .font(.system(size: 14))
                .frame(maxWidth: getRect().width / 3, alignment: .center)
                .foregroundColor(.gray)
            
            Text("Rs. "+String(format: "%.2f", product.price))
                .font(.system(size: 16))
                .frame(maxWidth: getRect().width / 3, alignment: .center)
                .foregroundColor(Color("FPurple"))
        })
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
        .background(
            Color.white.cornerRadius(25)
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.showSearchPage = true
                sharedData.detailProduct = product
                sharedData.showDetails = true
            }
        }
    }
}

#Preview {
    Home()
}
