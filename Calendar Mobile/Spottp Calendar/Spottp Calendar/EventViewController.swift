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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        day?.removeFromEvents(event!)
        context.delete(event!)
        
        // Save and go back
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addUpdateEventTapped(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // When creating a new event
        if event == nil {
            let context = appDelegate.persistentContainer.viewContext
            event = Event(context: context)
            eid = NSUUID().uuidString
        }
        
        event!.eid = eid
        event!.title = eventTitleTextField.text
        event!.start = startTextField.text
        event!.end = endTextField.text
        event!.desc = descriptionTextField.text
        event!.day = day
        
        // Save and go back
        day?.addToEvents(event!)
        appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
}
