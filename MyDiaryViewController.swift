//
//  MyDiaryViewController.swift
//  MyPracticeApp
//
//  Created by Welltime on 18/06/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit
import FSCalendar

class MyDiaryViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate ,UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var Calendar: FSCalendar!
    var Patient_Names: [String] = ["Jhon Smith", "Saleena Gomez", "Leo Decaprio"]
    var Appt_Duration: [String] = ["12:00 pm - 12:15 pm", "12:15 pm - 12:45 pm", "12:50 pm - 1:00 pm"]
var Appt_Time: [String] = ["12:00 pm", "12:00 pm", "1:00 pm"]
  
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        
        Calendar.scrollDirection = .Vertical
        Calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
       Calendar.selectDate(Calendar.dateWithYear(2015, month: 10, day: 10))
Calendar.scope = .Week

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///// ******************* TableView Delegate Methods ****************** //////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.Patient_Names.count;
    }

   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   
        var cell: AppointmentTableViewCell!
       
            cell = tableView.dequeueReusableCellWithIdentifier("AppointmentCell", forIndexPath: indexPath) as! AppointmentTableViewCell
        
        
    cell.txt_patient_name.text=Patient_Names[indexPath.row]
    cell.txt_appt_duration.text=Appt_Duration[indexPath.row]
     cell.txt_appt_time.text=Appt_Time[indexPath.row]
        return cell
        
     
       
    }
    
    ///// ******************* Calendar Delegate Methods ****************** //////////
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2015, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 10, day: 31)
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        let day = calendar.dayOfDate(date)
        return day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
    }
    
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return [13,24].containsObject(calendar.dayOfDate(date)) ? UIImage(named: "icon_cat") : nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func postDataToURL() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://ds8223.dedicated.turbodns.co.uk/AppointmentorWebsite/OnlineServices/RestServices.svc/GetFreeAppointmentChunks"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        
        let service=["ServiceCode":"1","DefaultDuration":"PT30M"]
        
        let customerTypeCode=["CustomerTypeCode":"P"]
        
        let customer=["CustomerType":customerTypeCode]
        
        
        
        let dic = ["SearchStartDate":"2016-08-01T00:00:00Z","SearchEndDate":"2016-09-05T00:00:00Z","Service":service,"Customer":customer]
        
              
       
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("238", forHTTPHeaderField: "Content-Length")
        request.setValue("Basic TXlQcmFjdGljZUFwcEFjY2Vzczp3MyEhdDFtRVAzQWN0IWMzVlBQ", forHTTPHeaderField: "Authorization")
        request.setValue("abc123", forHTTPHeaderField: "serviceProviderAccessKey")
        request.setValue("ds8223.dedicated.turbodns.co.uk", forHTTPHeaderField: "Host")
        
        do {
         
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    print(error?.code)
                    return
                    
                    //////
                    
                    
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                //                    self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
    }

}
