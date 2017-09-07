//
//  ProductListViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/21/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class ProductListViewController: UIViewController {

    
    @IBOutlet var table: UITableView?
    
    let root = Database.database().reference()
    var items: [ProductEntity]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackItem()
        
        let item = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        
        
        
        let productsRef = root.child("Product")
        productsRef.observe(DataEventType.value, with: { (snap) in
            print(snap)
            if let object = snap.value as? [String : Any] {
                self.items = [ProductEntity]()
                for key in object.keys {
                    if let item = object[key] as? [String : Any]{
                        self.items?.append(ProductEntity.init(node: item))
                    }
                }
                self.table?.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didTapAdd(sender: UIBarButtonItem) -> Void {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductComposerViewController") as? ProductComposerViewController{
            controller.categoryRef = root.child("Product")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension ProductListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let array = items {
            count = array.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.imgView?.image = ProductEntity.defaultIcon()
        if let array = items {
            let product = array[indexPath.row]
            cell.loadImage(url: product.file)
            cell.title?.text = product.name
            cell.about?.text = product.about
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if let array = self.items,
                array.count > indexPath.row {
                let product = array[indexPath.row]
                let ref = root.child("Product")
                if let child_id = product.id as String? {
                    let productRef = ref.child(child_id)
                    productRef.removeValue()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let array = self.items,
            array.count > indexPath.row {
            //            let product = array[indexPath.row]
            //            let ref = root.child("Product")
            //            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController,
            //                let child_id = product.id as String? {
            //                controller.ref = ref.child(child_id)
            //                controller.product = product
            //                self.navigationController?.pushViewController(controller, animated: true)
            //            }
            //            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductComposerViewController") as? ProductComposerViewController {
            //                self.navigationController?.pushViewController(controller, animated: true)
            //            }
        }
    }
}




class ProductCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView?
    @IBOutlet var title: UILabel?
    @IBOutlet var about: UILabel?
    
    func loadImage(url: String?) -> Void {
        if let img_url = url,
            let file_url = URL.init(string: img_url) {
            imgView?.af_setImage(withURL: file_url,
                                 placeholderImage: nil,
                                 filter: nil,
                                 progress: nil,
                                 progressQueue: DispatchQueue.init(label: "Some"),
                                 imageTransition: UIImageView.ImageTransition.flipFromRight(1),
                                 runImageTransitionIfCached: true, completion: { (data) in
                                    if let img = data.result.value {
                                        self.imgView?.image = img
                                    }
            })
        }
    }
}
