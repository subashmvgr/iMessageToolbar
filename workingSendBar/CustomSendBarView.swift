//
//  CustomSendBarView.swift
//  workingSendBar
//
//  Created by Subash Dantuluri on 8/28/16.
//  Copyright © 2016 Subash Dantuluri. All rights reserved.
//

import UIKit

class CustomSendBarView: UIView, HeightChangeDelegate {
    weak var keyboardObserver: KeyboardObserver?
    
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: CustomTextView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = NSBundle.mainBundle().loadNibNamed("CustomSendBarView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        textView.delegate = self
        textView.maxNumberOfLines = 4
        textView.textViewDelegate = self
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    // MARK: - View positioning and layout -
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, 44)
    }
    
    
    // MARK: - HeightChangeDelegate method -
    func textViewHeightChanged(textView: CustomTextView, newHeight: CGFloat) {
        
        let padding: CGFloat = 15
        let height = padding + newHeight
        
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.firstItem as! NSObject == self {
                constraint.constant = height < 44 ? 44 : height
            }
        }
        
        frame.size.height = height
        if let ko = keyboardObserver {
            ko.updateHeight(height)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.textView.updateSize()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    
}
