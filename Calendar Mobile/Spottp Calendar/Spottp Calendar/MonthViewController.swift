//
//  MonthViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/28/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var monthCollectionView: UICollectionView!
    
    let dates:[String] = [" ", " ", " ", " ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", " "]
    
    let events = [[["start": "10:00AM", "end": "12:00PM", "title": "open mic", "desc": "don't forget to bring my jazz hands"]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        // Calculate size based on screen size
        let weekWidth = UIScreen.main.bounds.width
        let dayWidth = weekWidth / 7 - 3
        let dayHeight = UIScreen.main.bounds.height / 6 - 3
        let weekHeight = dayHeight / 2
        
        
        // Header size
        layout.headerReferenceSize = CGSize(width: weekWidth, height: weekHeight);
        
        // Each item size
        layout.itemSize = CGSize(width: dayWidth, height: dayHeight)
        
        // Spacing between each item
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
     
        monthCollectionView.collectionViewLayout = layout
    }
    
    // CollectionView methods:
    
    // Set header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "monthViewHeader", for: indexPath as IndexPath)
        return headerView
    }
    
    // How many items to display in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    // Populate each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        
        cell.dateLabel.text = dates[indexPath.row]
        
        return cell
    }
}
