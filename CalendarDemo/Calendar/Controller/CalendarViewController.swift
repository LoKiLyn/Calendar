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
    
    @IBOutlet internal weak var previousButton: UIButton!
    @IBOutlet internal weak var currentDateTextField: DateTextField!
    @IBOutlet internal weak var nextButton: UIButton!
    @IBOutlet internal weak var collectionView: UICollectionView!
    @IBOutlet internal weak var dateLabel: UILabel!
    @IBOutlet internal weak var dailyTextView: UITextView!
    internal let leftSwipeGesture = UISwipeGestureRecognizer()
    internal let rightSwipeGesture = UISwipeGestureRecognizer()
    internal let dateArray = ["日","一","二","三","四","五","六"]
    internal var date = Date(){
        didSet{
            self.collectionView.reloadData()
        }
    }
    internal var selectedIndexPath: IndexPath = []
    internal var selectedComponents: DateComponents = DateComponents(){
        didSet{
            self.dailyTextView.text = UserDefaults.standard.value(forKey: selectedComponents.description) as! String!
            self.dateLabel.text = "\(selectedComponents.year!)年\(selectedComponents.month!)月\(selectedComponents.day!)日"
        }
    }
    
    weak var delegate: CalendarViewControllerDelegate?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedComponents = dateInfo(date: date)
        currentDateTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingDidEnd)
        dailyTextView.text = UserDefaults.standard.value(forKey:dateInfo(date: date).description) as! String!
        configCurrentDateTitle()
        configGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.dailyTextView.text = UserDefaults.standard.value(forKey: selectedComponents.description) as! String!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: CalendarDetailViewController.self){
            let destinationViewController = segue.destination as! CalendarDetailViewController
            self.delegate = destinationViewController
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    internal func textFieldDidChanged(){
        self.date = currentDateTextField.selectedDate!
    }
    
    internal func configCurrentDateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-yyyy"
        let dateString = dateFormatter.string(from: date)
        self.currentDateTextField.text = dateString
    }
    
    internal func configGestures() {
        leftSwipeGesture.direction = .left
        rightSwipeGesture.direction = .right
        leftSwipeGesture.addTarget(self, action: #selector(gestureDidSwiped))
        rightSwipeGesture.addTarget(self, action: #selector(gestureDidSwiped))
        self.view.addGestureRecognizer(leftSwipeGesture)
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    
    //MARK: - Events
    
    @IBAction func previousButtonPressed(_ sender: Any?) {
        var components = DateComponents()
        components.month = -1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any?) {
        var components = DateComponents()
        components.month = 1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        self.dailyTextView.resignFirstResponder()
        performSegue(withIdentifier: "presentCalendarDetail", sender: self)
        self.delegate?.calendarDidSelect(index: selectedIndexPath, date: selectedComponents)
    }
    
    internal func gestureDidSwiped(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            print("SwipeLeft")
            nextButtonPressed(sender)
        }else {
            print("SwipeRight")
            previousButtonPressed(sender)
        }
    }
    
    
    // MARK: - Notification
    /*
    internal func regNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardWillChangeFrame(noti: Notification) {
        let infoDict = noti.userInfo
        let beginKeyboardRect = (infoDict?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
        let endKeyboardRect = (infoDict?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let yOffset = (endKeyboardRect?.origin.y)! - (beginKeyboardRect?.origin.y)!
        var inputFieldRect = self.view.frame
        inputFieldRect.origin.y += yOffset
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = inputFieldRect
        })
    }
    */
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
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item >= firstWeekDayThisMonth(date: date) - 1 && (indexPath.item - firstWeekDayThisMonth(date: date) + 2) <= totalDaysThisMonth(date: date) {
            var selectedComponents = dateInfo(date: date)
            selectedComponents.day = indexPath.item - firstWeekDayThisMonth(date: date) + 2
            self.selectedComponents = selectedComponents
            self.selectedIndexPath = indexPath
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
