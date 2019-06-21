//
//  main.swift
//  NewPomo
//
//  Created by omatty198 on 2019/06/22.
//  Copyright © 2019 omatty198. All rights reserved.
//

import Foundation
import EventKit

func run() {
    
    let arguments = CommandLine.arguments
    print(arguments)
    requestAccess(arguments)
}

func requestAccess(_ arguments: [String]) {
    let store = EKEventStore()
    store.reset()
    store.requestAccess(to: EKEntityType.reminder, completion: { granted, error in
        print("granted: \(granted)\nerror: \(error.debugDescription)")
        if !granted {
            requestAccess(arguments)
        } else {
            print("request ok")
        }
    })
    let cal = store.defaultCalendarForNewReminders()
    
    let reminder = EKReminder(eventStore: store)
    if !arguments[1].isEmpty {
        reminder.title = arguments[1]
    } else {
        reminder.title = "none"
    }
    reminder.calendar = cal
    reminder.priority = 1
    
    // NOTE: 30分後
    var interval = "1800"
    if arguments.count > 2 {
        interval = arguments[2]
        print("time is \(interval) sec")
    } else {
        print("default time is 30min")
    }
    
    let intInterval = Int(interval) ?? 0
    
    let date = Date().addingTimeInterval(TimeInterval(intInterval))
    let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
    reminder.dueDateComponents = Calendar.current.dateComponents(components, from: date)
    
    let alarm = EKAlarm.init(absoluteDate: date)
    reminder.addAlarm(alarm)
    
    do {
        try store.save(reminder, commit: true)
    } catch let err {
        fatalError(err.localizedDescription)
    }
    print("🚀タスク:\(arguments[0])  --->  追加完了\n")
}

run()
