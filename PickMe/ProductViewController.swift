//
//  ProductViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/11/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var energy: UITextField!
    @IBOutlet var index: UITextField!
    @IBOutlet var about: UITextView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var uploadButton: UIButton!
    
    
    var product: Product!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.init(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapEdit(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        uploadButton.layer.borderWidth = 2
        uploadButton.layer.borderColor = uploadButton.tintColor.cgColor
        uploadButton.layer.cornerRadius = uploadButton.bounds.width/2
        loadProduct(prod: product)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProduct(prod: Product) -> Void{
        name.text = prod.title
        about.text = prod.about
        energy.text = prod.energy
        index.text = prod.index
    }
    
    func didTapEdit(sender: UIBarButtonItem) -> Void{
        if let title = sender.title {
            if title == "Edit" {
                allowEditing(allow: true)
                sender.title = "Save"
            }else{
                allowEditing(allow: false)
                sender.title = "Edit"
                save()
            }
        }
    }
    
    func allowEditing(allow: Bool) -> Void {
        name.isUserInteractionEnabled = allow
        about.isUserInteractionEnabled = allow
        energy.isUserInteractionEnabled = allow
        index.isUserInteractionEnabled = allow
    }
    
    func save() -> Void{
        var isUpdated = false
        if let value = name.text,
            value != product.title{
            product.title = value
            isUpdated = true
        }
        
        if let value = about.text,
            value != product.about{
            product.about = value
            isUpdated = true
        }
        
        if let value = energy.text,
            value != product.energy{
            product.energy = value
            isUpdated = true
        }
        
        if let value = index.text,
            value != product.index{
            product.index = value
            isUpdated = true
        }
        
        if isUpdated {
            let alert = UIAlertController.init(title: "Product has beed updated",
                                               message: "would you like to apply all the changes to your product description ?",
                                               preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Yes",
                                               style: UIAlertActionStyle.default,
                                               handler: { (action) in
                let node = self.product.node
                self.ref.setValue(node)
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel",
                                               style: UIAlertActionStyle.cancel,
                                               handler: { (action) in
                self.loadProduct(prod: self.product)
            }))
            self.present(alert, animated: true, completion: nil)

        }
    }
}
