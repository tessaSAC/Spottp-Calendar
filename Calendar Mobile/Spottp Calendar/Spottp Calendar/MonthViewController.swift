//
//  MonthViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/28/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            }
    
    // CollectionView methods:
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {  // Unneeded if only 1 section
//        return 1
//    }
    
    // How many items to display in collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    // Display individual cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as UICollectionViewCell
        
//        let day = UITableView(named: "todaysEvents")
//        cell.dayView.day = day
        
        return cell
    }
}

