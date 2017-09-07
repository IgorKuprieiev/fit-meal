//
//  UserViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/1/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import AlamofireImage



class UserViewController: UIViewController {

    @IBOutlet weak var table: UITableView?
    var image_holder: UIImageView?
    var wall = [WallPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let table_view = table {
            table_view.estimatedSectionHeaderHeight = 300
            table_view.sectionHeaderHeight = UITableViewAutomaticDimension
            
            table_view.estimatedRowHeight = 300
            table_view.rowHeight = UITableViewAutomaticDimension
            table_view.reloadData()
            
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.tintColor = UIColor.black
            refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
            table_view.addSubview(refreshControl)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender: UIRefreshControl) -> Void {
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.init(uptimeNanoseconds: 1000)) {
            sender.endRefreshing()
            self.table?.reloadData()
        }
        
    }
}


extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wall.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserEventTableViewCell", for: indexPath) as! UserEventTableViewCell
        cell.background?.isShadowed = true
        cell.loadPost(post: wall[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "UserHeaderTableViewCell") as! UserHeaderTableViewCell
        header.delegate = self
        header.addShadow()
        header.addGradient(top: UIColor(red: 63/255, green: 144/255, blue: 255/255, alpha: 0.5),
                           bot: UIColor(red: 137/255, green: 255/255, blue: 144/255, alpha: 0.5))
        return header
    }
}

extension UserViewController: UserHeaderDelegate {
    
    func didTapAvatar(img: UIImageView?) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: {
            self.image_holder = img
        })
    }
    
    func didTapPhoto() {
        
    }
    
    func didTapPost() {
        
    }
    
    
    func didTapEdit(sender: UIButton?) {
        if let popController = storyboard?.instantiateViewController(withIdentifier: "EditUserViewController") as? EditUserViewController,
            let button = sender {
        
        var height = 150 as CGFloat
            if let parent = button.superview{
                height = parent.bounds.height - button.frame.minY
            }
            
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.preferredContentSize = CGSize.init(width: 250, height: height)
            
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.right
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = button // button
        popController.popoverPresentationController?.sourceRect = button.bounds
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
        
        }
    }
    
    
}


extension UserViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}


//MARK: - UIImagePickerControllerDelegate
extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image_holder?.image = img
        }
        dismiss(animated: true, completion: {
            self.image_holder = nil
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            self.image_holder = nil
        })
    }
}

//MARK: - Shadow View

class BackgroundView: UIView {
    
    public var isShadowed: Bool = false
    public var colors: [UIColor]?
    
    override var bounds: CGRect {
        didSet {
            if self.isShadowed{
                setupShadow()
            }
            
            if self.colors != nil{
                setupGradient()
            }
        }
    }
    
    private func setupGradient() {
        guard let gradient_colors = self.colors else {
            self.gradient(colors: [UIColor]())
            return
        }
        self.gradient(colors: gradient_colors)
    }
    
    private func setupShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        
        let shadow_frame = self.bounds.insetBy(dx: 10, dy: 0)
        self.layer.shadowPath = UIBezierPath(rect: shadow_frame).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

    }
}



//MARK: - Table View Cell

class UserEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: BackgroundView?
    @IBOutlet weak var photo: UIImageView?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var content: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func loadPost(post: WallPost) -> Void {
        self.content?.text = post.content
        self.date?.text = post.time_stamp
        if let url_str = post.media,
            let url = URL.init(string: url_str){
            loadMedia(url: url)
        }
    }
    
    private func loadMedia(url: URL) -> Void {
        photo?.af_setImage(withURL: url,
                             placeholderImage: nil,
                             filter: nil,
                             progress: nil,
                             progressQueue: DispatchQueue.init(label: "Some"),
                             imageTransition: UIImageView.ImageTransition.flipFromRight(1),
                             runImageTransitionIfCached: true, completion: { (data) in
                                if let img = data.result.value {
                                    self.photo?.image = img
                                }
        })
    }
}


protocol UserHeaderDelegate {
    func didTapAvatar(img: UIImageView?) -> Void
    func didTapPost() -> Void
    func didTapPhoto() -> Void
    func didTapEdit(sender: UIButton?) -> Void
}


class UserHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var background: BackgroundView?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var avatar_background: UIView?
    @IBOutlet weak var avatar: UIImageView?
    
    @IBOutlet weak var avatar_upload: UIButton?

    
    var delegate: UserHeaderDelegate?
    
    
    public func loadProfile(profile: Any) -> Void {
        
    }
    
    func addShadow() {
        background?.isShadowed = true
    }
    
    func addGradient(top: UIColor, bot: UIColor) -> Void {
        background?.colors = [top , bot]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let rounded = self.avatar_background {
            rounded.layer.cornerRadius = rounded.bounds.width/2
            rounded.layer.borderColor = UIColor.black.cgColor
            rounded.layer.borderWidth = 2
        }
    }

    
    @IBAction func didTapSettings(sender: UIButton) -> Void {
        if let responder = self.delegate {
            responder.didTapEdit(sender: sender)
        }
        //TODO: Open new page in popover stile
    }
    
    
    @IBAction func didTapAvatar(sender: UIButton) -> Void {
        if let responder = self.delegate {
            responder.didTapAvatar(img: self.avatar)
        }
    }
    
    @IBAction func didTapPost(sender: UIButton) -> Void {
        if let responder = self.delegate {
            responder.didTapPost()
        }

    }
    
    @IBAction func didTapPhoto(sender: UIButton) -> Void {
        if let responder = self.delegate {
            responder.didTapPhoto()
        }

    }
}

extension UserHeaderTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.name?.text = textField.text
        self.endEditing(true)
        return false
    }
}




