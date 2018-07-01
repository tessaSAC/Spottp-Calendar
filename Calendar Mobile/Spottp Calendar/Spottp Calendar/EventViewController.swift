//
//  EventViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/28/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelTapped(_ sender: Any) {
        print("this works")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addEventTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let event = Event(context: context)
        
        let eid = NSUUID().uuidString
        
        event.eid = eid
        event.title = eventTitleTextField.text
        event.start = startTextField.text
        event.end = endTextField.text
        event.desc = descriptionTextField.text
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}
