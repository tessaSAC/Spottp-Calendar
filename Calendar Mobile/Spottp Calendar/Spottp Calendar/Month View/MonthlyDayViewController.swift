//
//  MonthlyDayViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 7/1/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
     @IBOutlet weak var start: UILabel!
     @IBOutlet weak var end: UILabel!
     @IBOutlet weak var title: UILabel!
}

class MonthlyDayViewController: UITableViewController {
    
    var day: Day? = nil
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if day != nil {
            events = day!.events!.array as! [Event]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayTableCell") as! DayTableViewCell
        let event = events[indexPath.row]
        
        print([indexPath.row])
        
        cell.start?.text = event.start
        cell.end?.text = event.end
        cell.title?.text = event.title
        
        return cell
    }

    

}
