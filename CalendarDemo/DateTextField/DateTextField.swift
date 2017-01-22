//
//  DateTextField.swift
//  PbrApp
//
//  Created by 宋鹏程 on 2017/1/16.
//  Copyright © 2017年 北京物灵智能科技有限公司. All rights reserved.
//

import UIKit


@IBDesignable class DateTextField: UITextField {
    
    // MARK: - Property
    
    var selectedDate: Date? {
        get {
            return self.datePicker.date
        }
        set {
            if let selectedDateUnpack = newValue {
                self.datePicker.date = selectedDateUnpack
                self.text = self.dateString(from: selectedDateUnpack)
            } else {
                self.datePicker.date = Date()
                self.text = nil
            }
        }
    }
    
    @IBOutlet internal weak var dateInputView: UIView!
    @IBOutlet internal weak var datePicker: UIDatePicker!
    
    
    // MARK: - Private
    
    private func dateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Constructor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initFromNib()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let menuController = UIMenuController.shared
        menuController.setMenuVisible(false, animated: false)
        return false
    }
    
    // MARK: - Events
    /* 这里可以即使改变输入值，但会使<取消>、<保存>按钮失去意义 */
    @IBAction func inputDatePickerValueChanged(sender: UIDatePicker) {
        
    }
    
}


extension DateTextField: InputAccessoryViewDelegate {
    
    func inputAccessoryViewDidPressedCancelButtonHandle() {
        self.resignFirstResponder()
    }
    
    func inputAccessoryViewDidPressedCommitButtonHandle() {
        self.selectedDate = self.datePicker.date
        self.resignFirstResponder()
    }
}


// MARK: - InitFromNib

extension DateTextField {
    
    private func dateInputViewFromNib() -> UIView {
        let nib = UINib(nibName: "DateInputView", bundle: Bundle(for: type(of: self)))
        let _dateInputView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return _dateInputView
    }
    
    private func inputAccessoryViewFromNib() -> UIView {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 44)
        let _inputAccessoryView = InputAccessoryView(frame: rect)
        _inputAccessoryView.delegate = self
        return _inputAccessoryView
    }
    
    internal func initFromNib() {
        self.inputView = self.dateInputViewFromNib()
        self.inputAccessoryView = self.inputAccessoryViewFromNib()
        self.datePicker.addTarget(self, action: #selector(inputDatePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    override func prepareForInterfaceBuilder() {
        self.datePicker.date = Date()
    }
}
