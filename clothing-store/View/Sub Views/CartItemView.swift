//
//  CartItemView.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemView: View {
    @Binding var product: Product
    var body: some View {
        HStack(spacing: 15){
            WebImage(url: URL(string: product.imageURL))
                .resizable()
                .indicator(.activity) // Activity indicator while loading
                .scaledToFit() // Scale the image to fit the frame
                .frame(width: 100, height: 100)
            
            VStack(spacing: 8){
                HStack{
                    Text(product.name)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .frame(alignment: .leading)
                    
                    Text("Rs. "+String(format: "%.2f", product.price))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                }

                

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

                HStack(spacing: 10){
                    Text("Quantity")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button {
                        product.quantity = (product.quantity > 0 ? (product.quantity - 1) : 0)
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color("FPurple"))
                            .cornerRadius(15)
                    }
                    
                    Text("\(product.quantity)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button {
                        product.quantity += 1

                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color("FPurple"))
                            .cornerRadius(15)
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
    Home()
}
