//
//  ProfileViewController.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/10/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var container: UIScrollView?
    @IBOutlet var header: UIView?
    @IBOutlet var avatar_bachground: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearNavigationBar(isClear: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let shadow_view = self.header {
            shadow_view.dropShadow()
            var colors = [UIColor]()
            colors.append(UIColor(red: 63/255, green: 144/255, blue: 255/255, alpha: 0.5))
            colors.append(UIColor(red: 32/255, green: 190/255, blue: 255/255, alpha: 0.5))
            colors.append(UIColor(red: 137/255, green: 255/255, blue: 144/255, alpha: 0.5))
            shadow_view.gradient(colors: colors)
        }
    }
    
    
    func clearNavigationBar(isClear: Bool) -> Void {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if isClear{
            self.navigationController?.navigationBar.alpha = 0
            self.navigationController?.view.backgroundColor = .clear
            
        }else{
            self.navigationController?.view.backgroundColor = .gray
            self.navigationController?.navigationBar.alpha = 1
        }
    }
}


extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -50 {
            scrollView.contentOffset = CGPoint.init(x: 0, y: -50)
        }
        
        if let nav_frame = self.navigationController?.navigationBar.frame,
            let header_frame = self.header?.frame {
            if scrollView.contentOffset.y > (header_frame.origin.y + header_frame.height - nav_frame.origin.y - nav_frame.height) {
                self.clearNavigationBar(isClear: false)
            }else{
                self.clearNavigationBar(isClear: true)
            }
            
        }
    }
    
    
    
}
