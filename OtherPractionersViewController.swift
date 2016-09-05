//
//  OtherPractionersViewController.swift
//  MyPracticeApp
//
//  Created by Welltime on 11/07/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit
import SwiftyJSON
class OtherPractionersViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

 
    
    @IBOutlet weak var tblView: UITableView!
  var alert : UIAlertView = UIAlertView(title:nil , message: "Loading..." , delegate: nil, cancelButtonTitle: nil)
    
  
    var dentist_list = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tblView.registerClass(PractitionerTableViewCell.self, forCellReuseIdentifier:  "PractitionerTableViewCell")
        
        
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
loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///// ******************* TableView Delegate Methods ****************** //////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dentist_list.count;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let vc = OtherPractionersAppointmentViewController() //change this to your class name
//        vc.dentist_forename=self.dentist_list[indexPath.row][0]
//        vc.dentist_surname=self.dentist_list[indexPath.row][1]
//        vc.dentist_title=self.dentist_list[indexPath.row][2]
//        vc.dentist_service_provider_code=self.dentist_list[indexPath.row][3]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("OtherPractionersAppointment") as! UIViewController
        self.presentViewController(vc2, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var cell: PractitionerTableViewCell!
       // if (cell==nil)
       // {
            cell = tableView.dequeueReusableCellWithIdentifier("PractitionerCell", forIndexPath: indexPath) as! PractitionerTableViewCell
        
        //}
        
        
        cell.txt_name.text=self.dentist_list[indexPath.row][0] + " " + self.dentist_list[indexPath.row][1]
               return cell
        
        
    }

    
    func loadData() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://ds8223.dedicated.turbodns.co.uk/AppointmentorWebsite/OnlineServices/RestServices.svc/GetAllServiceProviders"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        //.sharedSession
        //        let json = JSON(["SearchStartDate":"2016-08-01T00:00:00Z", "SearchEndDate":"2016-08-30T00:00:00Z","Service":["ServiceCode":1,"DefaultDuration":"PT30M"],"Customer":["CustomerType":["CustomerTypeCode":"P"]]])
        //        print(json)
        
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue("Basic TXlQcmFjdGljZUFwcEFjY2Vzczp3MyEhdDFtRVAzQWN0IWMzVlBQ", forHTTPHeaderField: "Authorization")
        request.setValue("abc123", forHTTPHeaderField: "serviceProviderAccessKey")
        request.setValue("ds8223.dedicated.turbodns.co.uk", forHTTPHeaderField: "Host")
        
        do {
            //  let jsonObject: AnyObject = json.object
            //            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
            
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
        //        print("POST: " + postString)
                
                

                do{
                    let nudgesJSONResult = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    

                    
                    if let json = nudgesJSONResult  as? NSArray {
                        for item in json {
                            var dentist = [String]()
                            if let forename = item.valueForKey("ForeName") {
                               
                                dentist.append((forename as! String))
                                
                                
                        }
                        if let lastname = item.valueForKey("SurName") {
                            dentist.append((lastname as! String))
                        
                        
                    }
                        if let title = item.valueForKey("Title") {
                            dentist.append((title as! String))
                            
                        }
                        if let service_provider_code = item.valueForKey("ServiceProviderCode") {
                             dentist.append((service_provider_code as! String))
                            
                        }
                        self.dentist_list.append(dentist)
                            
                        }
                    }
                        }
                    
                catch {
                    print("Error with Json: \(error)")
                }
            }
        self.alert.dismissWithClickedButtonIndex(-1, animated: true)
     
            
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
