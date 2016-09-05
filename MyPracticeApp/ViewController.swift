//
//  ViewController.swift
//  MyPracticeApp
//
//  Created by Welltime on 17/06/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func login_click(sender: AnyObject) {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var rem_date_string: String = userDefaults.stringForKey("REMINDER_DATE")!
       
        var today_date: NSDate = NSDate()
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var today_date_string: String = formatter.stringFromDate(today_date)
        if (rem_date_string == today_date_string) {
            var calendar: NSCalendar = NSCalendar.currentCalendar()
            var components: NSDateComponents = NSDateComponents()
            components.month = 1
            var reminder_date: NSDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])!
            formatter.dateFormat = "dd/MM/yyyy"
            rem_date_string = formatter.stringFromDate(reminder_date)
            userDefaults.setObject(rem_date_string, forKey: "REMINDER_DATE")
        }
        
        let vc = PurchaseViewController() //change this to your class name
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

