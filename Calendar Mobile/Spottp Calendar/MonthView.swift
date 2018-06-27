//
//  MonthView.swift
//  Spottp Calendar
//
//  Created by tessa on 6/26/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIdx: Int, year: Int)
}

class MonthView: UIView {
    let monthsArr : [String] = ["JAN ☃️", "FEB 💞", "MAR 🌸", "APR ☔️", "MAY ⛅️", "JUN 🌞", "JUL 🏄🏻‍♀️", "AUG 🏝", "SEP 🤾🏾‍♀️", "OCT 🎃", "NOV 🦃", "DEC 🎄"]
    var currentMonthIdx : Int = 0
    var currentYear : Int = 0
    var delegate = MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        currentMonthIdx = Calendar.currentComponent(.month, from: Date()) - 1  // Because months are 0-indexed
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
        buttonLeft.isEnabled = false  // Don't let user turn back time 😱💦
    }
    
    @objc func monthNavButtonsAction(sender: UIButton) {
        // Right button tapped
        if sender == buttonRight {
            currentMonthIdx += 1
            if currentMonthIdx > 11 {
                currentMonthIdx = 0
                currentYear += 1
            }
        }
        // Left button tapped
        else {
            currentMonthIdx -= 1
            if currentMonthIdx < 0 {
                currentMonthIdx = 11
                currentYear -= 1
            }
        }
        
        nowLabel.text = "\(monthsArr[currentMonthIdx]) \(currentYear))"
        delegate?.didChangeMonth(monthIdx: currentMonthIdx, year: currentYear)
    }
    
    // Arrange navigation buttons
    func setupViews() {
        self.addSubview(nowLabel)
        nowLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nowLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nowLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nowLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        nowLabel.text = "\(monthsArr[currentMonthIdx]) \(currentYear))"
        
        self.addSubview(buttonLeft)
        buttonRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonRight.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        buttonRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonRight.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.addSubview(buttonRight)
        buttonRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
        buttonRight.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        buttonRight.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonRight.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
        
    // Navigation buttons
    
    let nowLabel: UILabel = {
        let label = UILabel()
        label.text = "Month Year"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let buttonLeft: UIButton = {
        let button = UIButton()
        button.setTitle("↢", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(monthNavButtonsAction(sender: )), for: .touchUpInside)
        return button
    }()
    
    let buttonRight: UIButton = {
        let button = UIButton()
        button.setTitle("↣", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(monthNavButtonsAction(sender: )), for: .touchUpInside)
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}

