//
//  DayViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/30/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

// Custom eventsTableViewCell:
class EventsTableViewCell: UITableViewCell {
    // Aparently since this was defined in the storyboard, it's tightly coupled with the view controller so I'll leave it here
    // http://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/custom-cells
    
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
}

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var day: Day? = nil
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        // Assuming Day is passed in
        if day != nil {
            navigationBar.title = "\(day!.month).\(day!.date) plans"
            events = day!.events
        }
        
        // Don't forget to refresh the view!!!!!
        eventsTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as! EventsTableViewCell
        let event = events[indexPath.row]
        
        print([indexPath.row])
        
        cell.start?.text = event.start
        cell.end?.text = event.end
        cell.title?.text = event.title
        cell.desc?.text = event.desc
        
        return cell
    }

    // EDITING a tableViewCell:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as! EventsTableViewCell
        let event = events[indexPath.row]
        
        performSegue(withIdentifier: "eventSegue", sender: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EventViewController
        nextVC.day = day
        nextVC.event = sender as? Event
    }
}
