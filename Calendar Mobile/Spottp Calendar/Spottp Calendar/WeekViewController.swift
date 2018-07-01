//
//  WeekViewController.swift
//  Spottp Calendar
//
//  Created by tessa on 6/30/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    let weekdays = ["mo", "tu", "we", "th", "fr", "sa", "su"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        
        // Calculate size based on screen size
        let dayWidth = weekWidth / 7 - 3
        let weekHeight = UIScreen.main.bounds.height / 12
        
        // Each item size
        layout.itemSize = CGSize(width: weekWidth, height: weekHeight)
        
        // Spacing between each item
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        weekCollectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
        
        //        array[indexPath.row]
        
        return cell
    }

}
