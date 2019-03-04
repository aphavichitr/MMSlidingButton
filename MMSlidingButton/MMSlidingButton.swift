//
//  MMSlidingButton.swift
//  MMSlidingButton
//
//  Created by Mohamed Maail on 6/7/16.
//  Copyright © 2016 Mohamed Maail. All rights reserved.
//
//  Modified by Andrew Phavichitr on 2/26/19.
//

import Foundation
import UIKit

protocol SlideButtonDelegate {
    func buttonStatus(status: String, sender: MMSlidingButton)
}

@IBDesignable class MMSlidingButton: UIView {
    
    var delegate: SlideButtonDelegate?
    
    @IBInspectable var dragPointWidth: CGFloat = 70 {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var dragPointColor: UIColor = UIColor.darkGray {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var dragPointImageName: UIImage = UIImage() {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var dragPointText: String = "" {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var dragPointTextColor: UIColor = UIColor.white {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var dragPointCornerRadius: CGFloat = 30 {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = UIColor.gray {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var buttonText: String = "UNLOCK" {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var buttonTextColor: UIColor = UIColor.white {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = 30 {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var unlockedColor: UIColor = UIColor.black {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var unlockedText: String = "UNLOCKED" {
        didSet {
            setStyle()
        }
    }
    
    @IBInspectable var unlockedTextColor: UIColor = UIColor.white {
        didSet {
            setStyle()
        }
    }
    
    var buttonFont = UIFont(name: "Roboto-Medium", size: 16)
    
    var dragPoint            = UIView()
    var buttonLabel          = UILabel()
    var dragPointButtonLabel = UILabel()
    var imageView            = UIImageView()
    var unlocked             = false
    var layoutSet            = false
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        if !layoutSet {
            self.setUpButton()
            self.layoutSet = true
        }
    }
    
    func setStyle() {
        // set drag point
        self.dragPoint.frame.size.width     = self.dragPointWidth
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.imageView.image                = self.dragPointImageName
        self.dragPointButtonLabel.text      = self.dragPointText
        self.dragPointButtonLabel.textColor = self.dragPointTextColor
        self.dragPoint.layer.cornerRadius   = self.dragPointCornerRadius
        
        // set button
        self.backgroundColor                = self.buttonColor
        self.buttonLabel.text               = self.buttonText
        self.buttonLabel.textColor          = self.buttonTextColor
        self.buttonLabel.font               = self.buttonFont
        self.layer.cornerRadius             = self.buttonCornerRadius
    }
    
    func setUpButton() {
        // set up button
        self.backgroundColor                = self.buttonColor
        
        // set up dragPoint
        self.dragPoint                      = UIView(frame: CGRect(x: 0, y: 0, width: dragPointWidth, height: self.frame.size.height))
        self.dragPoint.backgroundColor      = self.dragPointColor
        self.dragPoint.layer.cornerRadius   = self.dragPointCornerRadius
        
        self.addSubview(self.dragPoint)
        
        // set up dragPoint constraints
        self.dragPoint.translatesAutoresizingMaskIntoConstraints = false
        self.dragPoint.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3).isActive = true
        self.dragPoint.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.dragPoint.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.dragPoint.widthAnchor.constraint(equalToConstant: self.dragPointWidth).isActive = true
        
        // set up button text
        if !self.buttonText.isEmpty {
            self.buttonLabel                = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.buttonLabel.textAlignment  = .center
            self.buttonLabel.text           = self.buttonText
            self.buttonLabel.textColor      = self.buttonTextColor
            self.buttonLabel.font           = self.buttonFont
            
            self.addSubview(self.buttonLabel)
        }
        
        // set up dragPoint text
        if !self.dragPointText.isEmpty {
            self.dragPointButtonLabel               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.dragPointButtonLabel.textAlignment = .center
            self.dragPointButtonLabel.text          = self.dragPointText
            self.dragPointButtonLabel.textColor     = self.dragPointTextColor
            self.dragPointButtonLabel.font          = self.buttonFont

            self.dragPoint.addSubview(self.dragPointButtonLabel)
        }
        
        self.bringSubview(toFront: self.dragPoint)
        
        // set up dragPoint image
        if self.dragPointImageName != UIImage() {
            self.imageView                  = UIImageView(frame: CGRect(x: 0, y: 0, width: self.dragPointWidth, height: self.dragPoint.frame.size.height))
            self.imageView.contentMode      = .center
            self.imageView.image            = self.dragPointImageName
            
            self.dragPoint.addSubview(self.imageView)
        }
        
        self.layer.masksToBounds = true
        
        // start detecting pan gesture
        let panGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(self.panDetected(sender:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        self.dragPoint.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panDetected(sender: UIPanGestureRecognizer) {
        var translatedPoint = sender.translation(in: self)
        translatedPoint     = CGPoint(x: translatedPoint.x, y: self.frame.size.height / 2)

        sender.view?.frame.origin.x = translatedPoint.x

        if sender.state == .ended {
            let velocityX = sender.velocity(in: self).x * 0.2
            var finalX    = translatedPoint.x + velocityX
            
            if finalX < 0{
                finalX = 0
            } else if finalX + self.dragPointWidth  >  (self.frame.size.width - 60) {
                unlocked = true
                self.unlock()
            }
            
            let animationDuration: Double = abs(Double(velocityX) * 0.0002) + 0.2
            
            UIView.transition(with: self, duration: animationDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
            }, completion: { (Status) in
                if Status{
                    self.animationFinished()
                }
            })
        }
    }
    
    func animationFinished() {
        if !unlocked {
            self.reset()
        }
    }
    
    //lock button animation (SUCCESS)
    func unlock() {
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: self.frame.size.width - self.dragPoint.frame.size.width - 3, y: 3, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status{
                self.dragPointButtonLabel.text      = self.unlockedText
//                self.imageView.isHidden             = true
                self.dragPoint.backgroundColor      = self.unlockedColor
                self.dragPointButtonLabel.textColor = self.unlockedTextColor
                self.delegate?.buttonStatus(status: "Unlocked", sender: self)
            }
        }
    }
    
    //reset button animation (RESET)
    func reset() {
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            self.dragPoint.frame = CGRect(x: 3, y: 3, width: self.dragPoint.frame.size.width, height: self.dragPoint.frame.size.height)
        }) { (Status) in
            if Status {
                self.dragPointButtonLabel.text      = self.buttonText
                self.imageView.isHidden             = false
                self.dragPoint.backgroundColor      = self.dragPointColor
                self.dragPointButtonLabel.textColor = self.dragPointTextColor
                self.unlocked                       = false
                //self.delegate?.buttonStatus("Locked")
            }
        }
    }
}
