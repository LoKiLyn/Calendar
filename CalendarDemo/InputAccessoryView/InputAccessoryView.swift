//
//  InputAccessoryView.swift
//  PbrApp
//
//  Created by 宋鹏程 on 2017/1/16.
//  Copyright © 2017年 北京物灵智能科技有限公司. All rights reserved.
//

import UIKit


protocol InputAccessoryViewDelegate : NSObjectProtocol {
    func inputAccessoryViewDidPressedCancelButtonHandle()
    func inputAccessoryViewDidPressedCommitButtonHandle()
}

@IBDesignable class InputAccessoryView: UIView {
    
    // MARK: - Public
    
    weak var delegate: InputAccessoryViewDelegate?
    
    
    // MARK: - Constructor

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initFromNib()
    }
    
    
    // MARK: - Events
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.delegate?.inputAccessoryViewDidPressedCancelButtonHandle()
    }
    
    @IBAction func commitButtonPressed(sender: UIButton) {
        self.delegate?.inputAccessoryViewDidPressedCommitButtonHandle()
    }
    
}


// MARK: - InitFromNib

extension InputAccessoryView {
    
    private func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
    
    private var contentView: UIView {
        if self.subviews.first == nil {
            let nib = UINib(nibName: self.nibName(), bundle: Bundle(for: type(of: self)))
            let _contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
            _contentView.translatesAutoresizingMaskIntoConstraints = false
            return _contentView
        } else {
            return self.subviews.first!
        }
    }
    
    private func layoutContentView() {
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    internal func initFromNib() {
        self.addSubview(self.contentView)
        self.layoutContentView()
    }
    
    override func prepareForInterfaceBuilder() {
        
    }
}
