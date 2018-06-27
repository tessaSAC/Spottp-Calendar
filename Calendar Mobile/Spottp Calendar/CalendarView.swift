//
//  CalendarView.swift
//  Spottp Calendar
//
//  Created by tessa on 6/26/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    var numDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]  // Will take care of leap year elsewhere
    var currentMonthIdx : Int = 0
    var currentYear : Int = 0
    var presentMonthIdx = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekday = 0  // Su-Sa daysArr
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    func initializeView() {
        // Set up dates
        currentMonthIdx = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekday = getFirstWeekday()
        
        // Calculate leap years
        if currentMonthIdx == 2 && currentYear % 4 == 0 {
            numDays[currentMonthIdx - 1] = 29
        }
        
        presentMonthIdx = currentMonthIdx
        presentYear = currentYear
        
        setupViews()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numDays[currentMonthIdx - 1] + firstWeekday - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: <#T##IndexPath#>) as! dateCVCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekday - 2 {
            let calculateDate = indexPath.row - firstWeekday + 2
            
            cell.isHidden = false
            cell.label.text = "\(calculateDate)"
            
            if calculateDate < todaysDate && currentYear == presentYear && currentMonthIdx == presentMonthIdx {
                cell.isUserInteractionEnabled = false
                cell.label.textColor = UIColor.white
            } else {
                cell.isUserInteractionEnabled = true
                cell.label.textColor = UIColor.black
            }
        }
    }
    
    func getFirstWeekday() -> Int {
        let day = ("\(currentYear)-\(currentMonthIdx)-01".date?.firstWeekday.weekday)!
        return day
    }
    
    func didChangeMonth(monthIdx: Int, year: Int) {
        currentMonthIdx = monthIdx + 1
        currentYear = year
        
        firstWeekday = getFirstWeekday()
        calendarCollectionView.reloadData()
        monthView.buttonLeft.isEnabled = !(currentMonthIdx == presentMonthIdx && currentYear == presentYear)
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        monthView.delegate = self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(calendarCollectionView)
        calendarCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        calendarCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        calendarCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        calendarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let monthView: MonthView = {
        let monthView = MonthView()
        monthView.translatesAutoresizingMaskIntoConstraints=false
        return monthView
    }()
    
    let weekdaysView: WeekdaysView = {
        let weekdaysView = WeekdaysView()
        weekdaysView.translatesAutoresizingMaskIntoConstraints = false
        return weekdaysView
    }()
    
    let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.backgroundColor=UIColor.clear
        calendarCollectionView.allowsMultipleSelection = false
        
        return calendarCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    var weekday : Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstWeekday : Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date : Date? {
        return String.dateFormatter.date(from: self)
    }
}
