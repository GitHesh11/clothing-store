//
//  Productdetails.swift
//  clothing-store
//
//  Created by Yesh Adithya on 2024-03-30.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct Productdetails: View {
    var animation: Namespace.ID
    var product:Product
    @EnvironmentObject var sharedData: SharedProductViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.presentationMode) var present
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            sharedData.showDetails = false
                        }
                    } label: {
                        Image("Back")
                            .font(.title2)
                             .foregroundColor(Color.black.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button {
                        if let currentUser = Auth.auth().currentUser {
                            withAnimation {
                                addToLiked()
                            }
                        }else {
                            withAnimation(.easeOut){
                                present.wrappedValue.dismiss()
                            }
                        }
                       
                    } label: {
                        Image("Liked")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(isLiked() ? .red : Color.black)
                    }

                }
                .padding()
                
                WebImage(url: URL(string: product.imageURL))
                    .resizable()
                    .indicator(.activity) // Activity indicator while loading
                    .scaledToFit() // Scale the image to fit the frame
                    .matchedGeometryEffect(id: "\(product.id)\(sharedData.showSearchPage ? "SEARCH": "IMAGE")", in: animation)
                    .frame(maxWidth: .infinity) // Set desired frame size
                    .padding(.horizontal)
            }
            .frame(height: getRect().height / 2.7)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 15, content: {
                    Text(product.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    Text("Rs. "+String(format: "%.2f", product.price))
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    Text(product.category + " - " + product.type.capitalized)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)

                    Text("Description")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    
                    
                    Text(product.description)
                        .font(.system(size: 15))
                    
                    HStack{
                        HStack {
                            Text("Size: ")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                            
                            Text(product.size)
                                .font(.system(size: 18))
                                .padding()
                                .background(
                                    Circle()
                                        .foregroundColor(Color("GrayBG"))
                                )
                        }
                         Spacer()

                        HStack{
                            Text("Color: ")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                            
                            Text(product.color)
                                .font(.system(size: 18))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .foregroundColor(Color("GrayBG"))
                                )
                        }
                    }
                    
                    Button(action: {
                        if let currentUser = Auth.auth().currentUser {
                            withAnimation {
                                addToCart()
                            }
                        }else {
                            withAnimation(.easeOut){
                                present.wrappedValue.dismiss()
                            }
                        }
                      
                    }, label: {
                        Text("\(isAddedToCart() ? "Added to Cart" : "Add to Cart")")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color("FPurple").cornerRadius(15))
                    })
                })
                .padding([.horizontal, .bottom], 20)
                .padding(.top, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("WhiteBG")
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                    .ignoresSafeArea()
            )
        }
        .animation(.easeInOut, value: sharedData.likedProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(
            Color("BG").ignoresSafeArea()
        )
    }
    
    func isAddedToCart()-> Bool{
        return sharedData.cartProducts.contains{ product in
            return self.product.id == product.id
        }
    }
    
    func isLiked()-> Bool{
        return sharedData.likedProducts.contains{ product in
            return self.product.id == product.id
        }
    }
    
    func addToCart(){
        if let index = sharedData.cartProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }){
            sharedData.cartProducts.remove(at: index)
        }else{
            sharedData.cartProducts.append(product)
        }
    }
    
    func addToLiked (){
        if let index = sharedData.likedProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }){
            sharedData.likedProducts.remove(at: index)
        }else{
            sharedData.likedProducts.append(product)
        }
    }
}

#Preview {
    Home()
}


struct CustomCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius ))
        return Path(path.cgPath )
    }
}
