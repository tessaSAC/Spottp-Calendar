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

    @IBAction func addEventTapped(_ sender: Any) {
        let eid = NSUUID().uuidString
         dismiss(animated: true, completion: nil)
    }
}
