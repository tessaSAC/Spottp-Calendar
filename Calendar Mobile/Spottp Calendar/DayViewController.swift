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
    
    var date: Int?
    var events: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if date != nil {
            // REST API location
            let url = URL(string: "https://spottp-calendar.firebaseapp.com/events/\(date!)")!
            
            // Fetch data
            let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
                if error != nil {
                    print("Failed to fetch events with error \(error!)")
                } else {
                    if let urlContent = data {
                        do {
                            // All the data as JSON
                            self.events = try [JSONSerialization.jsonObject(with: urlContent, options: .allowFragments)]
                            
                            // Don't forget to refresh the view!!!!!
                            DispatchQueue.main.async{
                                self.eventsTableView.reloadData()
                            }
                        } catch {
                            print("Failed to process JSON")
                        }
                    }
                }
            }
            task.resume()

            navigationBar.title = "June \(date!) plans"
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as! EventsTableViewCell
        let event = events[indexPath.row] as! [String: Any]
        
        // Unwrap (should be-)single inner object:
        for (_, value) in event {
            var event = value as! [String: String]
                
            cell.start?.text = event["start"]
            cell.end?.text = event["end"]
            cell.title?.text = event["title"]
            cell.desc?.text = event["desc"]
        }

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
        nextVC.event = sender as! [String: Any]
    }
}
