//
//  Wishlist.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import SwiftUI
import SDWebImageSwiftUI

struct Wishlist: View {
    @EnvironmentObject var sharedData: SharedProductViewModel
    @State var showDeleteOption: Bool = false
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    HStack{
                        
                        Button {
                            withAnimation(.easeInOut) {
                                sharedData.showWishListPage = false
                            }
                        } label: {
                            Image("Back")
                                .font(.title2)
                                 .foregroundColor(Color.black.opacity(0.7))
                        }
                        
                        Text("Wishlist")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                        Spacer()
                        Button{
                            withAnimation {
                                showDeleteOption.toggle()
                            }
                        } label: {
                            Image("delete")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                        }
                        .opacity(sharedData.likedProducts.isEmpty ? 0 : 1)
                    }
                    
                    if sharedData.likedProducts.isEmpty{
                        Group{
                            Image("searchBG")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: getRect().width / 3, height: getRect().height / 3)
                                .padding()
                                .padding(.top, 35)
                            
                            Text("No favourite yet.")
                                .font(.system(size: 25))
                                .fontWeight(.semibold)
                        }
                    } else {
                        VStack(spacing: 15){
                            ForEach(sharedData.likedProducts){product in
                                HStack(spacing: 0){
                                    if showDeleteOption{
                                        Button {
                                            sharedData.deleteProduct(product: product)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                        .padding(.trailing)

                                    }
                                    CardView(product: product)
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("BG")
                    .ignoresSafeArea()
            )
        }
    }
    
    @ViewBuilder
    func CardView(product: Product)-> some View {
        HStack(spacing: 15){
            WebImage(url: URL(string: product.imageURL))
                .resizable()
                .indicator(.activity) // Activity indicator while loading
                .scaledToFit() // Scale the image to fit the frame
                .frame(width: 100, height: 100)
            
            VStack(spacing: 8){
                Text(product.name)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(product.category)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("FPurple"))

                HStack{
                    HStack {
                        
                        Text("Size -")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text(product.size)
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                    }
                    HStack{
                        Text("Color -")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text(product.color)
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color("WhiteBG")
                .cornerRadius(15)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    Wishlist()
}
