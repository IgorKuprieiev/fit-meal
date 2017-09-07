//
//  CustomNavigationBar.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/31/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit

@IBDesignable class CustomNavigationBar: UIView {

    /// Gradient layer that is added on top of the view
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    /// Top color of the gradient layer
    @IBInspectable var topColor: UIColor = UIColor.black {
        didSet {
            updateUI()
        }
    }
    
    /// Bottom color of the gradient layer
    @IBInspectable var bottomColor: UIColor = UIColor.clear {
        didSet {
            updateUI()
        }
    }
    
    /// At which vertical point the layer should end
    @IBInspectable var bottomYPoint: CGFloat = 0.6 {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: bottomYPoint)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = frame
    }
    
    func adjustBackground(isClear: Bool) {
        if isClear == true {
            gradientLayer.isHidden = false
            backgroundColor = UIColor.clear
        } else {
            gradientLayer.isHidden = true
            backgroundColor = UIColor(red: CGFloat(54/255.0), green: CGFloat(54/255.0), blue: CGFloat(54/255.0), alpha: 1.0)
        }
    }

}
