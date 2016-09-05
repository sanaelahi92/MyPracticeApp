//
//  MainViewController.swift
//  MyPracticeApp
//
//  Created by Welltime on 03/08/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var paymentInfoContainer: UIView!
    @IBOutlet weak var otherPractitionerContainer: UIView!
    @IBOutlet weak var myDiaryContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.myDiaryContainer.alpha = 1
                self.otherPractitionerContainer.alpha = 0
                self.paymentInfoContainer.alpha = 0
            })
        } else if(sender.selectedSegmentIndex == 1) {
            UIView.animateWithDuration(0.5, animations: {
                self.myDiaryContainer.alpha = 0
                self.otherPractitionerContainer.alpha = 1
                self.paymentInfoContainer.alpha = 0
            })}
            else{
                UIView.animateWithDuration(0.5, animations: {
                    self.myDiaryContainer.alpha = 0
                    self.otherPractitionerContainer.alpha = 0
                    self.paymentInfoContainer.alpha = 1
           })
            }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
