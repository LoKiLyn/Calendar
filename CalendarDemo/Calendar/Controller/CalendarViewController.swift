//
//  CalendarViewController.swift
//  CalendarDemo
//
//  Created by 小白 on 2017/1/18.
//  Copyright © 2017年 LinJian. All rights reserved.
//

import UIKit

public protocol CalendarViewControllerDelegate: NSObjectProtocol {
    func calendarDidSelect(index: IndexPath, date: DateComponents)
}

class CalendarViewController: UIViewController {
    
    //MARK: - Property
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var currentDateTextField: DateTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CalendarViewControllerDelegate?
    internal let dateArray = ["日","一","二","三","四","五","六"]
    internal var date = Date(){
        didSet{
            self.collectionView.reloadData()
        }
    }

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        currentDateTextField.inputView = datePicker
        currentDateTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingDidEnd)
        configCurrentDateTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private
    
    internal func dateInfo(date: Date) -> (DateComponents) {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components
    }
    
    internal func firstWeekDayThisMonth(date: Date) -> (Int) {
        var components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        components.day = 1
        let firstDayOfMonthDate = Calendar.current.date(from: components)
        let firstWeekDay = Calendar.current.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay!
    }
    
    internal func totalDaysThisMonth(date: Date) -> (Int) {
        let totalDaysThisMonth:Range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!
        return totalDaysThisMonth.count
    }
    
    internal func configCurrentDateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-yyyy"
        let dateString = dateFormatter.string(from: date)
        self.currentDateTextField.text = dateString
    }
    
    internal func textFieldDidChanged(){
        self.date = currentDateTextField.selectedDate!
    }
    
    
    //MARK: - Events
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        var components = DateComponents()
        components.month = -1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        var components = DateComponents()
        components.month = 1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : 37
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentDateComponents = dateInfo(date: Date())
        var selectedComponents = dateInfo(date: date)
        selectedComponents.day = indexPath.item - firstWeekDayThisMonth(date: date) + 2
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayOfAWeekCell", for: indexPath) as! CalendarDateCell
            cell.dateLabel.text = dateArray[indexPath.item]
            return cell
        } else {
            let cell = collectionView .dequeueReusableCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarDateCell
            if indexPath.item < firstWeekDayThisMonth(date: date) - 1 {
                cell.dateLabel.text = " "
                cell.backgroundColor = UIColor.clear
            }else if indexPath.item >= firstWeekDayThisMonth(date: date) - 1 && (indexPath.item - firstWeekDayThisMonth(date: date) + 2) <= totalDaysThisMonth(date: date) {
                cell.dateLabel.text = "\(indexPath.item - firstWeekDayThisMonth(date: date) + 2)"
                if currentDateComponents == selectedComponents {
                    cell.backgroundColor = UIColor.orange
                }else{
                    cell.backgroundColor = UIColor.green
                }
            }else {
                cell.backgroundColor = UIColor.clear
                cell.dateLabel.text = " "
            }
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: CalendarDetailViewController.self){
            self.delegate = segue.destination as! CalendarDetailViewController
        }
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item >= firstWeekDayThisMonth(date: date) - 1 && (indexPath.item - firstWeekDayThisMonth(date: date) + 2) <= totalDaysThisMonth(date: date) {
        var selectedComponents = dateInfo(date: date)
        selectedComponents.day = indexPath.item - firstWeekDayThisMonth(date: date) + 2
        performSegue(withIdentifier: "presentCalendarDetail", sender: self)
        self.delegate?.calendarDidSelect(index: indexPath, date: selectedComponents)
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeItem : CGFloat = CGFloat(collectionView.bounds.size.width - 32 - 12) / 7.0
        let size = CGSize(width: sizeItem, height: sizeItem)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsetsMake(0, 0, 10, 0)
        return insets
    }
}
