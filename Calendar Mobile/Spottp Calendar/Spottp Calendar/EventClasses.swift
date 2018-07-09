//
//  EventClasses.swift
//  Spottp Calendar
//
//  Created by tessa on 7/8/18.
//  Copyright © 2018 tessa. All rights reserved.
//

import Foundation

class Day {
    var year: Int = 0
    var month: Int = 0
    var date: Int = 0
    var events: [Event] = []
    
    init(year: Int, month: Int, date: Int) {
        self.year = year
        self.month = month
        self.date = date
        self.events = []
    }
}

class Event {
    var day: Day
    var eid: String = ""
    var title: String = ""
    var desc: String = ""
    var start: String = ""
    var end: String = ""
    
    init(day: Day, eid: String, title: String, desc: String, start: String, end: String) {
        self.day = day
        self.eid = eid
        self.title = title
        self.desc = desc
        self.start = start
        self.end = end
    }
}
