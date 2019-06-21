//
//  main.swift
//  NewPomo
//
//  Created by omatty198 on 2019/06/22.
//  Copyright © 2019 omatty198. All rights reserved.
//

import Foundation
import EventKit

print("Hello, World!")

func run() {
    
    let arguments = CommandLine.arguments
    
    requestAccess(arguments)
    print(arguments)
    
    print("Hello, World! This is my command line tool")
    
}

func requestAccess(_ arguments: [String]) {
    let store = EKEventStore()
    store.reset()
    store.requestAccess(to: EKEntityType.reminder, completion: { granted, error in
        print(granted, error)
        if !granted {
            requestAccess(arguments)
        } else {
            print("ok!!")
        }
    })
    let cal = store.defaultCalendarForNewReminders()

    let re = EKReminder(eventStore: store)
    if !arguments[1].isEmpty {
        
        
        // TODO: terminalに表示するように
        // print
        re.title = arguments[1]
        print(re.title)
    } else {
        re.title = "none"
    }
    // re.title = arguments[0]//String(cString: arguments[0]!, encoding: .utf8)
    re.calendar = cal
    re.priority = 1
    let dateComp = DateComponents()
    
    var str = "1800"
    if !arguments[2].isEmpty {
        str = arguments[2]
        print("\(str)")
        // TODO: terminalに表示するように
        // print
    }
    
    let seconds = Int(str) ?? 0
    // NOTE: 30分後
    let date = Date().addingTimeInterval(TimeInterval(seconds))
    
    let calendar = Calendar.current
    var flags: Set<Calendar.Component>
    var comps: DateComponents?
    flags = [.year, .month, .day, .hour, .minute]
    //comps = Calendar.current.dateComponents(flags, from: date)
    let a = Calendar.current.dateComponents(flags, from: date)
    re.dueDateComponents = a
    
    //var alarmDate: Date? = nil
    //let alarmDate = a.date(from: flags)
    let alarm = EKAlarm.init(absoluteDate: date)
    re.addAlarm(alarm)
    
    do {
        try store.save(re, commit: true)
    } catch let err {
        fatalError(err.localizedDescription)
    }
    print("🚀タスク:\(arguments[0])  --->  追加完了\n")
}

run()
