//
//  FreeSlotsTableViewCell.swift
//  MyPracticeApp
//
//  Created by Welltime on 25/07/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit
import SwiftyJSON
class FreeSlotsTableViewCell: UITableViewCell {

    @IBOutlet weak var free_slot_time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func loadData() {
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://ds8223.dedicated.turbodns.co.uk/AppointmentorWebsite/OnlineServices/RestServices.svc/GetFreeAppointmentChunks"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        
        let json = JSON(["SearchStartDate":"2016-08-01T00:00:00Z", "SearchEndDate":"2016-08-30T00:00:00Z","Service":["ServiceCode":1,"DefaultDuration":"PT30M"],"Customer":["CustomerType":["CustomerTypeCode":"P"]]])
        print(json)
        
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("238", forHTTPHeaderField: "Content-Length")
        request.setValue("Basic TXlQcmFjdGljZUFwcEFjY2Vzczp3MyEhdDFtRVAzQWN0IWMzVlBQ", forHTTPHeaderField: "Authorization")
        request.setValue("abc123", forHTTPHeaderField: "serviceProviderAccessKey")
        request.setValue("ds8223.dedicated.turbodns.co.uk", forHTTPHeaderField: "Host")
        
        do {
            let jsonObject: AnyObject = json.object
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
            
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
