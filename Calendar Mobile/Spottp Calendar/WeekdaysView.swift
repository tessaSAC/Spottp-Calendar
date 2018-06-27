//
//  WeekdaysView.swift
//  Spottp Calendar
//
//  Created by tessa on 6/26/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit
class WeekdaysView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(monthStackView)
        monthStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Create weekday labels
        let daysArr : [String] = ["Su", "M", "T", "W", "Th", "F", "S"]
    
        for day in 0..<7 {
            let label = UILabel()
            label.text = daysArr[day]
            label.textAlignment = .center
            label.textColor = UIColor.black
            monthStackView.addArrangedSubview(label)
        }
    }
    
    // Evenly distribute days across grid
    let monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
