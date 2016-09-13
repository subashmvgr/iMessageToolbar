//
//  KeyboardObserver.swift
//  workingSendBar
//
//  Created by Subash Dantuluri on 8/28/16.
//  Copyright © 2016 Subash Dantuluri. All rights reserved.
//

import UIKit

let FrameDidChangeNotification = "FrameDidChangeNotification"

class KeyboardObserver: UIView {
    
    private weak var observedView: UIView?
    private var defaultHeight: CGFloat = 44
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, defaultHeight)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        removeKeyboardObserver()
        if let _newSuperview = newSuperview {
            addKeyboardObserver(_newSuperview)
        }
        
        super.willMoveToSuperview(newSuperview)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object as? NSObject == superview {
            keyboardDidChangeFrame(superview!.frame)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func updateHeight(height: CGFloat) {
        
        frame.size.height = height
        
        setNeedsLayout()
        layoutIfNeeded()
        
        
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.firstItem as! NSObject == self {
                constraint.constant = height < defaultHeight ? defaultHeight : height
            }
        }
    }
    
    private func addKeyboardObserver(newSuperview: UIView) {
        observedView = newSuperview
        newSuperview.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    private func removeKeyboardObserver() {
        if observedView != nil {
            observedView!.removeObserver(self, forKeyPath: "center")
            observedView = nil
        }
    }
    
    private func keyboardDidChangeFrame(frame: CGRect) {
        let userInfo = [UIKeyboardFrameEndUserInfoKey: NSValue(CGRect:frame)]
        NSNotificationCenter.defaultCenter().postNotificationName(FrameDidChangeNotification, object: nil, userInfo: userInfo)
    }
    
    deinit {
        removeKeyboardObserver()
    }
}
