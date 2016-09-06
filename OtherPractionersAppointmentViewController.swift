//
//  OtherPractionersAppointmentViewController.swift
//  MyPracticeApp
//
//  Created by Welltime on 18/07/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit
import FSCalendar

class OtherPractionersAppointmentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var alert : UIAlertView = UIAlertView(title:nil , message: "Loading..." , delegate: nil, cancelButtonTitle: nil)
    var Free_Slots_Time: [String] = ["12:00 pm", "1:00 pm", "2:00 pm"]
    var dentist_forename=NSString()
    var dentist_surname=NSString()
    var dentist_title=NSString()
    var dentist_service_provider_code=NSString()
    var appointments_list = [[String]]()
    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointments_list.count;
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: FreeSlotsTableViewCell!
        
        cell = tableView.dequeueReusableCellWithIdentifier("FreeSlotsCell", forIndexPath: indexPath) as! FreeSlotsTableViewCell
        
        if(appointments_list.count > 0)
        { cell.free_slot_time.text=appointments_list[0][0]}
       
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
       print("calendar did select date \(calendar.stringFromDate(date))")
    }
    
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return [13,24].containsObject(calendar.dayOfDate(date)) ? UIImage(named: "icon_cat") : nil
    }
    
    func loadData() {
        var viewBack:UIView = UIView(frame: CGRectMake(83,0,100,60))
        
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 57, 57))
        loadingIndicator.center = viewBack.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        viewBack.addSubview(loadingIndicator)
        viewBack.center = self.view.center
        alert.setValue(viewBack, forKey: "accessoryView")
        loadingIndicator.startAnimating()
        
        
        alert.show()
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://ds8223.dedicated.turbodns.co.uk/AppointmentorWebsite/OnlineServices/RestServices.svc/GetFreeAppointmentChunks"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        //.sharedSession
        //        let json = JSON(["SearchStartDate":"2016-08-01T00:00:00Z", "SearchEndDate":"2016-08-30T00:00:00Z","Service":["ServiceCode":1,"DefaultDuration":"PT30M"],"Customer":["CustomerType":["CustomerTypeCode":"P"]]])
        //        print(json)
        
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("422", forHTTPHeaderField: "Content-Length")
        request.setValue("Basic TXlQcmFjdGljZUFwcEFjY2Vzczp3MyEhdDFtRVAzQWN0IWMzVlBQ", forHTTPHeaderField: "Authorization")
        request.setValue("abc123", forHTTPHeaderField: "serviceProviderAccessKey")
        request.setValue("ds8223.dedicated.turbodns.co.uk", forHTTPHeaderField: "Host")
        
        do {
            let service=["ServiceCode":"1","DefaultDuration":"PT30M"]
            
            let customerTypeCode=["CustomerTypeCode":"P"]
            
           let customer=["CustomerType":customerTypeCode]
            
             let service_provider=["ForeName":"Mike","SurName":"Ross","Title":" ","ServiceProviderCode":"10000002"]
            
            let dic = ["SearchStartDate":"2016-08-01T00:00:00Z","SearchEndDate":"2016-09-05T00:00:00Z","Service":service,"Customer":customer,"ServiceProviders":service_provider]
            for (key, value) in dic {
                print("\(key) -  Dictionary value \(value)")
            }
          
           let jsonData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            //  let jsonObject: AnyObject = json.object
                      request.HTTPBody = jsonData
            
            //try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
            
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse   where
                realResponse.statusCode == 200 else {
                 self.alert.dismissWithClickedButtonIndex(-1, animated: true)
                    
                    print("Not a 200 response")
                    print(data)
             
                    print(response)
                    return
                    
                    //////
                    
                    
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
         //       print("POST: " + postString)
                
                
                
                do{
                    
                    
                    let nudgesJSONResult = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
                   
                    
                    
                   
                    if let dict = nudgesJSONResult as? NSDictionary {
                        
                      
                        for var i = 0; i < dict["GetFreeAppointmentChunksResult"]!.count; i += 1 {
                       
                        
                        
                        
                           var appt_time = [String]()
                            
                           if let start_time = dict["GetFreeAppointmentChunksResult"]![i]!["ChunkStartDateTime"] as? [String: AnyObject]{
                            
                        appt_time.append((start_time as! String))
                            
                            
                                                        }
                            
                        if let end_time = dict["GetFreeAppointmentChunksResult"]![i]!["ChunkEndDateTime"] {
                                                            appt_time.append((end_time as! String))
                                                            
                                                            
                                                        }
                                                     self.appointments_list.append(appt_time)
                            
                                                    }
                    
                    print(self.appointments_list)
                  }}
                    
                catch {
                    print("Error with Json: \(error)")
                }
                
                 self.alert.dismissWithClickedButtonIndex(-1, animated: true)
            }
           
            
            
           self.tblView.reloadData()
        }).resume()
        
        
    }

    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
