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
    
    // Variables to help track events per diem
    let year = 2018
    let month = 06
    
    // Days of the month
    let dates:[String] = [" ", " ", " ", " ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", " "]
    
    // Create events pointer
    var events: [Day] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
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
    
    // Set header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "monthViewHeader", for: indexPath as IndexPath)
        return headerView
    }
    
    // Fetch all events
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Right now I believe this will create a new set of Days every time the user starts the app
        dates.forEach{date in
            let currentDay = Int(date)
            
            let day = Day(context: context)
            
            if currentDay != nil {
                day.date = Int32(currentDay!)
                day.month = Int32(month)
                day.year = Int32(year)
            } else {
                day.date = 0
                day.month = 0
                day.year = 0
            }
            
            appDelegate.saveContext()
            events.append(day)
        }
            
        monthCollectionView.reloadData()
    }
    
    // How many items to display in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    // Populate each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
//        let day = events[indexPath.row]
        
        cell.dateLabel.text = dates[indexPath.row]
        
        return cell
    }
    
    // Tap on a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Int(dates[indexPath.row]) != nil {
            let day = events[indexPath.row]
            performSegue(withIdentifier: "daySegue", sender: day)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DayViewController
        nextVC.day = sender as? Day
    }
}
