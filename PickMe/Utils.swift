//
//  Utils.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/18/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import  UIKit


typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure:@escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}


extension Date {
    
    func getDayOfWeek() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func dayOfWeek(short: Bool) -> String? {
        let dateFormatter = DateFormatter()
        var str = "EEEE"
        if short {
            str = "EEE"
        }
        dateFormatter.dateFormat = str
        return dateFormatter.string(from: self).capitalized
    }
    
}


extension UIButton {
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure:@escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    func closureAction() {
        guard let targetClosure = targetClosure else {
            return
        }
        targetClosure(self)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}


extension UIViewController {

    func setupBackItem() -> Void {
        let item = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: UIBarButtonItemStyle.done, target: self, action:#selector(back(sender:)))
        self.navigationItem.setLeftBarButton(item, animated: false)
    }
    
    @objc private func back(sender: UIBarButtonItem) -> Void {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        }
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        
        let shadow_frame = self.bounds.insetBy(dx: 10, dy: 0)
        self.layer.shadowPath = UIBezierPath(rect: shadow_frame).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func gradient(colors: [UIColor]){
        let gradient = CAGradientLayer.init(frame: self.bounds, colors: colors)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}


