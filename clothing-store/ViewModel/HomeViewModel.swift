//
//  HomeViewModel.swift
//  clothing-store
//
//  Created by Bagi on 2024-03-30.
//

import Foundation
import Firebase
import Combine

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filterProducts: [Product] = []
    @Published var uniqueCategories: Set<String> = []
    @Published var uniqueTypes: Set<String> = []
    @Published var showMoreProductOnCategory : Bool = false
    
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    
    @Published var searchProducts: [Product]?
    
    
    let ref = Database.database().reference().child("products")
    
    var searchCancellable: AnyCancellable?
    
    init(){
        searchCancellable = $searchText.removeDuplicates().debounce(for: 0.5, scheduler: RunLoop.main).sink(receiveValue: { str in
            if str != ""{
                self.filterProductBySearch()
            }else{
                self.searchProducts = nil
            }
        })
    }
    
    func fetchData() {
        ref.observe(.value) { snapshot in
            var fetchedProducts: [Product] = []
            var uniqueCategories: Set<String> = ["All"]
            var uniqueTypes: Set<String> = ["All"]
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any] {
                   
                    let id = snapshot.key
                    if let name = dict["name"] as? String,
                       let description = dict["description"] as? String,
                       let category = dict["category"] as? String,
                       let type = dict["type"] as? String,
                       let color = dict["color"] as? String,
                       let price = dict["price"] as? Double,
                       let size = dict["size"] as? String,
                       let imageURL = dict["image_url"] as? String  {
                        let product = Product(id: id, name: name, category: category, description: description, type: type, color: color, size: size, price: price, imageURL: imageURL, quantity: 1)
                        fetchedProducts.append(product)
                        uniqueCategories.insert(category)
                        uniqueTypes.insert(type)
                        
                    }
                }
            }
            DispatchQueue.main.async {
                self.products = fetchedProducts
                self.filterProducts = Array(fetchedProducts.prefix(8))
                self.uniqueCategories = uniqueCategories
                self.uniqueTypes = uniqueTypes
            }
        }
    }
    
    func filterByCategory(category: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let results: [Product]
            if category == "All" {
                results = self.products
            } else {
                results = self.products.lazy.filter { product in
                    return product.category == category
                }
            }
            
            DispatchQueue.main.async {
                self.filterProducts = Array(results.prefix(4))
            }
        }
    }
    
    func filterByTypes(type: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let results: [Product]
            if type == "All" {
                results = self.products
            } else {
                results = self.products.lazy.filter { product in
                    return product.type == type
                }
            }
            
            DispatchQueue.main.async {
                self.filterProducts = Array(results.prefix(6))
            }
        }
    }
    
    func filterProductBySearch() {
        DispatchQueue.global(qos: .userInteractive).async {
            let results: [Product]
                results = self.products.lazy.filter { product in
                    return product.name.lowercased().contains(self.searchText.lowercased())
                }
            
            
            DispatchQueue.main.async {
                self.searchProducts = Array(results)
            }
        }
    }
}

