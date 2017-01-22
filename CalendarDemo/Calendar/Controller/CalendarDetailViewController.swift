//
//  CalendarDetailViewController.swift
//  CalendarDemo
//
//  Created by 小白 on 2017/1/20.
//  Copyright © 2017年 LinJian. All rights reserved.
//

import UIKit

protocol CalendarDetailViewControllerDelegate: NSObjectProtocol {
    func calendarDetailTextFieldInfo(text: String)
}

class CalendarDetailViewController: UIViewController {

    // MARK: - Private
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoTextField: UITextField!
    
    weak var delegate: CalendarDetailViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Events
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.delegate?.calendarDetailTextFieldInfo(text: self.infoTextField.text!)
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarDetailViewController: CalendarViewControllerDelegate {
    func calendarDidSelect(index: IndexPath, date: DateComponents) {
        self.infoLabel.text = "SelectDate:\(date.year!) year" + "\(date.month!) month" + "\(date.day!) day"
    }
}
