//
//  FoodManager.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/10/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import Firebase


protocol RemoteEntityProtocol {
    func composeRemoteEntity() -> [String : Any];
    func isValid() -> Bool;
}

class RemoteEntity: NSObject, RemoteEntityProtocol {
    var id: String?
    
    public init(node: [String : Any]){
        super.init()
        id = node["id"] as? String
    }
    
    public init(id: String) {
        super.init()
        self.id = id
    }
    
    func composeRemoteEntity() -> [String : Any] {
        var params = [String : Any]()
        if let value = id {
            params["id"] = value
        }
        return params
    }
    
    func isValid() -> Bool {
        guard let value = id else {
            return false
        }
        return !value.isEmpty
    }
}

class ProductEntity: RemoteEntity {
    var name: String?
    var about: String?
    var calories_throw: CGFloat?
    var calories_consume: CGFloat?
    var fat: CGFloat?
    var protein: CGFloat?
    var carbs: CGFloat?
    var file: String?
    
    override init(node: [String : Any]){
        super.init(node: node)
        name = node["name"] as? String
        about = node["about"] as? String
        calories_throw = node["calories_throw"] as? CGFloat
        calories_consume = node["calories_consume"] as? CGFloat
        fat = node["fat"] as? CGFloat
        protein = node["protein"] as? CGFloat
        carbs = node["carbs"] as? CGFloat
        file = node["file"] as? String
    }
    
    override init(id: String) {
        super.init(id: id)
    }
    
    
    override func isValid() -> Bool {
        guard let _ = id else {
            return false
        }
        
        guard let _ = name else {
            return false
        }
        
        guard let _ = about else {
            return false
        }
        
        guard let _ = protein else {
            return false
        }
        
        guard let _ = carbs else {
            return false
        }
        
        guard let _ = fat else {
            return false
        }
        
        guard let _ = calories_throw else {
            return false
        }
        
        return true
    }
    
    override func composeRemoteEntity() -> [String : Any] {
        var params = super.composeRemoteEntity()
        
        if let value = name {
            params["name"] = value
        }
        
        if let value = about {
            params["about"] = value
        }
        
        if let value = protein {
            params["protein"] = value
        }
        
        if let value = carbs {
            params["carbs"] = value
        }
        
        if let value = fat {
            params["fat"] = value
        }
        
        if let value = calories_throw {
            params["calories_throw"] = value
        }
        
        if let value = file {
            params["file"] = value
        }
        return params
    }
    
    public static func defaultIcon() -> UIImage? {
        return UIImage.init(named: "product_icon")
    }
}

class DishComponentEntity: RemoteEntity {
    var product: ProductEntity?
    var quantity: Int?
    var weight: Int?
    var capacity: Int?
    var fat: CGFloat?
    var protein: CGFloat?
    var carbonate: CGFloat?
}

class DishEntity: RemoteEntity {
    var products: [DishComponentEntity]?
    var calories: CGFloat?
}




class Product: NSObject {
    
    var title: String?
    var about: String?
    var energy: String?
    var index: String?
    var imgRef: String?
    var id: String!
    
    convenience init(node: [String : Any]){
        self.init()
        title = node["title"] as? String
        about = node["about"] as? String
        energy = node["energy"] as? String
        index = node["index"] as? String
        imgRef = node["imgRef"] as? String
        id = node["id"] as? String
    }
    
    public var node: [String: Any] {
        var params = [String : Any]()
        if let value = title {
            params["title"] = value
        }
        
        if let value = about {
            params["about"] = value
        }
        
        if let value = energy {
            params["energy"] = value
        }
        
        if let value = index {
            params["index"] = value
        }
        
        if let value = imgRef {
            params["imgRef"] = value
        }
        
        params["id"] = id
      
        return params
    }
}


let root = Database.database().reference()



class FoodManager {
    
    let foodRef = root.child("Food")
    static let shared = FoodManager()
    
    func fetchAll() -> [Product] {
        var items = [Product]()
        if let products = foodRef.value(forKey: "Product") as? [[String : Any]]{
            for product in products {
                items.append(Product.init(node: product))
            }
        }
        return items
    }
    
    func addProduct(product: Product) -> Void {
        let productsRef = foodRef.child("Product")
        productsRef.setValue(product.node, andPriority: nil) { (err, dataRef) in
            
        }
    }
}
