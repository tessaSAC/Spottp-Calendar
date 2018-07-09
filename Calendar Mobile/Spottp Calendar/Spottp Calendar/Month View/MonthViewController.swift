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
    var events: [String: Any] = [:]
    
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
        
        // REST API location
        let url = URL(string: "https://spottp-calendar.firebaseapp.com/events")!
        
        // Fetch data
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error != nil {
                print("Failed to fetch events with error \(error!)")
            } else {
                if let urlContent = data {
                    do {
                        // All the data as JSON
                        self.events = try JSONSerialization.jsonObject(with: urlContent, options:.allowFragments) as! [String:Any]
                        
                        // Iterate through all dates and populate events if extant
//                        self.dates.forEach{ date in
//                            if Int(date) != nil {
//                                let currentDay = self.events[Int(date)!]
//
//                                if jsonResult[date] != nil {
//
//                                    // For each event create a new Event and add it to the current Day
//                                    for (_, jsonEvent) in jsonResult[date] as! [String: Any] {
//                                        let event = Event(day: currentDay, eid: "", title: "", desc: "", start: "", end: "")
//
//                                        // It seems like I have to keep this inner loop bc eid isn't detected otherwise fsr
//                                        for (key, value) in jsonEvent as! [String: Any] {
//                                            if key == "eid" { event.eid = value as! String }
//                                            if key == "title" { event.title = value as! String }
//                                            if key == "desc" { event.desc = value as! String }
//                                            if key == "start" { event.start = value as! String }
//                                            if key == "end" { event.end = value as! String }
//                                        }
//
//                                        currentDay.events.append(event)
//                                    }
//                                }
//
//                                // Reload monthCollectionView when data is done loading
//                                // https://stackoverflow.com/questions/44870523/swift-view-loads-before-http-request-is-finished-in-viewdidload
                                DispatchQueue.main.async{
                                    self.monthCollectionView.reloadData()
                                }
//                            }
//                        }
                    } catch {
                        print("Failed to process JSON")
                    }
                }
            }
        }
        task.resume()
    }
    
    // How many items to display in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    // Populate each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = monthCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        let day = events[String(indexPath.row)] as? [String: Any]
        var schedule = ""
        
        if(day != nil) {
            for (_, event) in day! {
                let event =  event as! [String: Any]
                schedule += "\(event["start"]!)~\n\(event["end"]!)\n\(event["title"]!)\n"
            }

        }
        
        cell.dateLabel.text = dates[indexPath.row]
        cell.todaysEventsLabel.text = schedule
        
        return cell
    }
    
    // Tap on a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Int(dates[indexPath.row]) != nil {
            let day = events[String(indexPath.row)]
            performSegue(withIdentifier: "daySegue", sender: day)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DayViewController
        nextVC.day = sender as? Day
    }
}
