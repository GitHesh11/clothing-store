//
//  Cart.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import SwiftUI

struct Cart: View {
    @EnvironmentObject var sharedData: SharedProductViewModel
    @State var showDeleteOption: Bool = false
    var body: some View {
        NavigationView{
            VStack(spacing: 10 ){
                ScrollView(.vertical, showsIndicators: false){
                    VStack{

                        HStack{
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    sharedData.showCartPage = false
                                }
                            } label: {
                                Image("Back")
                                    .font(.title2)
                                     .foregroundColor(Color.black.opacity(0.7))
                            }
                            
                            
                            Text("Cart")
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
                            .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)
                        }
                        
                        if sharedData.cartProducts.isEmpty{
                            Group{
                                Image("cartBG")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: getRect().width / 3, height: getRect().height / 3)
                                    .padding()
                                    .padding(.top, 35)
                                
                                Text("Your cart is Empty.")
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                
                            }
                        } else {
                            VStack(spacing: 15){
                                ForEach($sharedData.cartProducts){$product in
                                    HStack(spacing: 0){
                                        if showDeleteOption{
                                            Button {
                                                sharedData.deleteCartProduct(product: product)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.trailing)

                                        }
                                        CartItemView(product: $product)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                
                if !sharedData.cartProducts.isEmpty{
                    Group{
                        HStack{
                            Text("Total")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(sharedData.getTotalPrice())")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(Color("FPurple"))
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Checkout")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color("FPurple"))
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05),radius:  5, x: 5, y: 5)
                        }
                        .padding(.vertical)

                    }
                    .padding(.horizontal,25)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("BG")
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    Cart()
}
