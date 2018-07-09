//
//  EventViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/28/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    // UI
    @IBOutlet weak var eventViewControllerTitle: UINavigationItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var addUpdateButton: UIButton!
    
    // Data
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // For in case an event will be edited
    var day: Day? = nil
    var event: Event? = nil
    var eid: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If an event is passed in for editing
        eventTitleTextField.text = event?.title
        startTextField.text = event?.start
        endTextField.text = event?.end
        descriptionTextField.text = event?.desc
        eid = event?.eid
        
        // Update UI as necessary
        if event != nil {
            eventViewControllerTitle.title = "edit event"
            addUpdateButton.setTitle("update", for: .normal)
            day = event!.day
        } else {
            deleteButton.isEnabled = false
            deleteButton.tintColor = UIColor.clear
        }
    }

    @IBAction func cancelTapped(_ sender: Any) {
        print("this works")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let date = String(day!.date)

        let deleteEndpoint: String = "https://spottp-calendar.firebaseapp.com/events/\(date)/\(eid!)"
        var request = URLRequest(url: URL(string: deleteEndpoint)!)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else {
                print("Failed to delete task")
                return
            }
            print("Deleted task successfully!")
        }
        task.resume()
    
        // Go back
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addUpdateEventTapped(_ sender: Any) {
        var restMethod = "PUT"
        var status = "200"
        
        // When creating a new event
        if event == nil {
            restMethod = "POST"
            status = "201"
            event = Event(day: day!, eid: "", title: "", desc: "", start: "", end: "")
            eid = NSUUID().uuidString
        }
        
        event!.eid = eid!
        event!.title = eventTitleTextField.text!
        event!.desc = descriptionTextField.text!
        event!.start = startTextField.text!
        event!.end = endTextField.text!
        
        // Put/Post to REST API
        let paramEvent = ["eid": eid as Any, "title": eventTitleTextField.text ?? "", "desc": descriptionTextField.text ?? "", "start": startTextField.text ?? "", "end": endTextField.text ?? "", "day": day!.date] as [String : Any]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: paramEvent, options: []) else { return }
        
        let url = URL(string: "https://spottp-calendar.firebaseapp.com/events")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = restMethod
        request.httpBody = httpBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for fundamental networking error
            guard let data = data, error == nil else {
                print("There was a problem uploading the event data: \(error!)")
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != Int(status) {                print("Expected status code: \(status), received: \(httpStatus.statusCode)")
                print(response!)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        task.resume()
        
        // https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
        // https://www.youtube.com/watch?v=aTj0ZLha1zE
        
        // Go back
        navigationController?.popViewController(animated: true)
    }
}
