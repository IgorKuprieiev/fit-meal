//
//  CreateProductViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/10/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase

class CreateProductViewController: UIViewController {

    @IBOutlet var name: UITextField?
    @IBOutlet var about: UITextView?
    @IBOutlet var energy: UITextField?
    @IBOutlet var index: UITextField?
    var productsRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem.init(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(didTapSave(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didTapSave(sender: UIBarButtonItem) -> Void {
        let product = Product.init()
        
        if let value = name?.text {
            product.title = value
        }
        
        if let value = energy?.text {
            product.energy = value
        }
        
        if let value = index?.text {
            product.index = value
        }
        
        if let value = about?.text {
            product.about = value
        }
        
        var node = product.node
        if node.count > 0 {
            let ref = productsRef.childByAutoId()
            product.id = ref.key
            node = product.node
            ref.setValue(node)
        }
        self.navigationController?.popViewController(animated: true)
    }

    

}
