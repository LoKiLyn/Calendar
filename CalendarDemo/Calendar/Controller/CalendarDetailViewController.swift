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
    var dateComponent: DateComponents?
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
        self.infoTextField.resignFirstResponder()
        //alert弹出
        let alert = UIAlertController(title: "Warning", message: "Quit without saving？", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            action in
                self.dismiss(animated: true)
            })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.infoTextField.resignFirstResponder()
        saveText()
        let alert = UIAlertController(title: "Save succeeded.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true) { 
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                self.dismiss(animated: true)
                self.dismiss(animated: true)
            })
        }
    }
    
    
    // MARK: - Public
    
    func saveText() {
        let userDefaults = UserDefaults.standard
        let key = dateComponent!.description
        userDefaults.set(self.infoTextField.text,forKey:key)
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
//        self.infoLabel.text = "SelectDate:\(date.year!) year" + "\(date.month!) month" + "\(date.day!) day"
        self.infoLabel.text = date.description
        dateComponent = date
    }
}

extension CalendarDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
