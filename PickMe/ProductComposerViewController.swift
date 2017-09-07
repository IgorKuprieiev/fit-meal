//
//  ProductComposerViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/17/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GrowingTextView
import MBProgressHUD

class ProductComposerViewController: UIViewController {

    @IBOutlet var container: UIScrollView?
    @IBOutlet var fields: [UITextField]?
    @IBOutlet var name: UITextField?
    @IBOutlet var about: GrowingTextView?
    
    @IBOutlet var protein: UITextField?
    @IBOutlet var carbs: UITextField?
    @IBOutlet var fat: UITextField?
    @IBOutlet var calories: UITextField?
    
    @IBOutlet var upload_img: UIImageView?
    @IBOutlet var upload_btn: UIButton?
    
    var save: UIBarButtonItem?
    
    var product: ProductEntity!
    var productRef: DatabaseReference!
    var categoryRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackItem()
        productRef = categoryRef.childByAutoId()
        product = ProductEntity(id: productRef.key)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        let item = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.save , target: self, action: #selector(didTapSave(sender:)))
        self.navigationItem.setRightBarButton(item, animated: false)
        save = item
        
        if let field_items = fields {
            for field_item in field_items {
                field_item.inputAccessoryView = createAccessoryView(input: field_item)
            }
        }
        
        if let view_item = about {
            view_item.inputAccessoryView = createAccessoryView(input: view_item)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(sender: Notification) -> Void {
        save?.isEnabled = false
        if let info = sender.userInfo,
            let frame_value = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue{
            let kb_size = frame_value.cgRectValue
            container?.contentInset = UIEdgeInsetsMake(0, 0, kb_size.height, 0)
        }
    }
    
    
    func keyboardWillHide(sender: Notification) -> Void {
        save?.isEnabled = true
        container?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    func validate() -> Bool {
        return product.isValid()
    }
    
    
    func uploadImage(img: UIImage, id: String, entity: ProductEntity) -> Void {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.animationType = MBProgressHUDAnimation.zoom
        hud.label.text = "Uploading image"
        hud.mode = .determinate
        if let task = RemoteStorage.uploadImage(img: img, name: id, callback: { (data, err) in
            if let url = data?.downloadURL() {
                entity.file = url.absoluteString
            }
            self.uploadEntity(entity: entity, indicator: hud)
        }) {
            task.observe(.progress, handler: { (snapshot) in
                hud.progressObject = snapshot.progress
            })
        }else{
            uploadEntity(entity: entity, indicator: hud)
        }
    }
    
    func uploadEntity(entity: ProductEntity, indicator: MBProgressHUD) -> Void {
        indicator.label.text = "Saving data"
        productRef.setValue(entity.composeRemoteEntity(), withCompletionBlock: { (err, ref) in
            indicator.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    func didTapSave(sender: UIBarButtonItem) -> Void {
        if /*product.isValid(),*/
            let img = upload_img?.image,
                 let id = product.id {
            uploadImage(img: img, id: id, entity: product)
        }else{
            let alert = UIAlertController.init(title: "Completion Error",
                                               message: "Please, compleate all the fields for your product entity",
                                               preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Got it", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func createAccessoryView(input: UITextInput) -> UIView {
        let accessory = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 40))
        accessory.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        let button = UIButton.init(frame: CGRect.init(x: 10, y: 0, width: 60, height: accessory.bounds.height))
        button.backgroundColor = UIColor.clear
        button.addTargetClosure { (btn) in
            self.view.endEditing(true)
            if let control = input as? UITextField {
                self.storeField(field: control)
            }
            
            if let control = input as? UITextView {
                self.storeArea(area: control)
            }
            
        }
        button.setTitle("DONE", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        accessory.addSubview(button)
        return accessory
    }
    
    func storeArea(area: UITextView) -> Void {
        if let value = area.text{
            if area == about {
                product.about = value
            }
        }
    }
    
    func storeField(field: UITextField) -> Void {
        if let value = field.text{
            if field == name {
                product.name = value
            }
            
            if field == protein {
                product.protein = CGFloat(value.floatValue)
            }
            
            if field == carbs {
                product.carbs = CGFloat(value.floatValue)
            }
            
            if field == fat {
                product.fat = CGFloat(value.floatValue)
            }
            
            if field == calories {
                product.calories_throw = CGFloat(value.floatValue)
            }
        }
    }
    
    
    
    @IBAction func didTapUpload(sender: UIButton) -> Void {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    
}


//MARK: - GrowingTextViewDelegate
extension ProductComposerViewController : GrowingTextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let scroll = container,
            let holder = textView.superview {
            let frame = holder.convert(textView.frame, to: scroll)
            scroll.scrollRectToVisible(frame, animated: true)
        }
    }
}


//MARK: - UITextFieldDelegate
extension ProductComposerViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let scroll = container,
            let holder = textField.superview {
            let frame = holder.convert(textField.frame, to: scroll)
            scroll.scrollRectToVisible(frame, animated: true)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ProductComposerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            upload_img?.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

