//
//  CustomTextView.swift
//  workingSendBar
//
//  Created by Subash Dantuluri on 8/28/16.
//  Copyright © 2016 Subash Dantuluri. All rights reserved.
//

import UIKit

protocol HeightChangeDelegate: UITextViewDelegate {
    func textViewHeightChanged(textView: CustomTextView, newHeight: CGFloat)
}

class CustomTextView: UITextView {
    
    override var contentSize: CGSize {
        didSet {
            updateSize()
        }
    }
    
    weak var textViewDelegate: HeightChangeDelegate? {
        didSet {
            delegate = textViewDelegate
        }
    }
    
    
    /// The maximum number of lines that will be shown before the text view will scroll. 0 = no limit
    var maxNumberOfLines: CGFloat = 0
    var expectedHeight: CGFloat = 0
    var minimumHeight: CGFloat {
        get {
            return ceil(font!.lineHeight) + textContainerInset.top + textContainerInset.bottom
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        scrollEnabled = false
    }
    
    func updateSize() {
        
        let roundedHeight = roundHeight()
        
        if roundedHeight >= 90 {
            expectedHeight = 90
            scrollEnabled = true
        } else {
            expectedHeight = roundedHeight
            scrollEnabled = false
        }
        
        if textViewDelegate != nil {
            textViewDelegate?.textViewHeightChanged(self, newHeight:expectedHeight)
        }
    }
    
    private func roundHeight() -> CGFloat {
        var newHeight: CGFloat = 0
        
        if let font = font {
            let attributes = [NSFontAttributeName: font]
            let boundingSize = CGSizeMake(frame.size.width, CGFloat.max)
            let size = (text as NSString).boundingRectWithSize(boundingSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            newHeight = ceil(size.height)
        }
        
        return newHeight + textContainerInset.top + textContainerInset.bottom
    }
}