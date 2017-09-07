//
//  DishListViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/21/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class DishListViewController: UIViewController {

    @IBOutlet var table: UITableView?
    
    let root = Database.database().reference()
    var items: [DishEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackItem()
        let item = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        
        let productsRef = root.child("Dish")
        productsRef.observe(DataEventType.value, with: { (snap) in
            print(snap)
            if let object = snap.value as? [String : Any] {
                self.items = [DishEntity]()
                for key in object.keys {
                    if let item = object[key] as? [String : Any]{
                        self.items?.append(DishEntity.init(node: item))
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
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DishComposerViewController") as? DishComposerViewController{
           // controller.categoryRef = root.child("Product")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
