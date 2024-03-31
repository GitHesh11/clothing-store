//
//  SharedProductViewModel.swift
//  clothing-store
//
//  Created by Yesh Adithya on 2024-03-30.
//

import SwiftUI

class SharedProductViewModel: ObservableObject {
    
    @Published var detailProduct: Product?
    @Published var showDetails:Bool = false
    
    @Published var showCartPage:Bool = false
    @Published var showWishListPage: Bool = false
    @Published var showProfilePage: Bool = false
    
    @Published var showSearchPage: Bool = false
    
    
    @Published var likedProducts: [Product] = [] {
        didSet {
            saveLikedProducts()
        }
    }
    
    @Published var cartProducts: [Product] = [] {
        didSet {
            saveCartProducts()
        }
    }
    
    private let likedProductsKey = "LikedProducts"
    private let cartProductsKey = "CartProducts"
    
    init() {
        // Load liked products and cart products from UserDefaults when initializing the view model
        loadLikedProducts()
        loadCartProducts()
    }
    
    private func saveLikedProducts() {
        // Encode likedProducts array to Data object
        if let encodedData = try? JSONEncoder().encode(likedProducts) {
            // Save the encoded data to UserDefaults
            UserDefaults.standard.set(encodedData, forKey: likedProductsKey)
        }
    }
    
    private func saveCartProducts() {
        // Encode cartProducts array to Data object
        if let encodedData = try? JSONEncoder().encode(cartProducts) {
            // Save the encoded data to UserDefaults
            UserDefaults.standard.set(encodedData, forKey: cartProductsKey)
        }
    }
    
    private func loadLikedProducts() {
        // Retrieve liked products data from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: likedProductsKey) {
            // Decode the data into [Product] array
            if let decodedProducts = try? JSONDecoder().decode([Product].self, from: savedData) {
                likedProducts = decodedProducts
            }
        }
    }
    
    private func loadCartProducts() {
        // Retrieve cart products data from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: cartProductsKey) {
            // Decode the data into [Product] array
            if let decodedProducts = try? JSONDecoder().decode([Product].self, from: savedData) {
                cartProducts = decodedProducts
            }
        }
    }
    
    func getTotalPrice()-> String {
        var total: Int = 0
        
        cartProducts.forEach { product in
            let price = product.price
            let quantity = product.quantity //Here we want to add qty
            let priceTotal = Double (quantity) * price
            
            total += Int(priceTotal)
        }
        
        return "Rs. \(total)"
    }
    

    
    func deleteProduct(product: Product){
        if let index = likedProducts.firstIndex(where: { currentproduct in
            return product.id == currentproduct.id
        }){
            let _ = withAnimation {
                likedProducts.remove(at: index)
            }
        }
    }
    
    func deleteCartProduct(product: Product){
        if let index = cartProducts.firstIndex(where: { currentproduct in
            return product.id == currentproduct.id
        }){
            let _ = withAnimation {
                cartProducts.remove(at: index)
            }
        }
    }
}
