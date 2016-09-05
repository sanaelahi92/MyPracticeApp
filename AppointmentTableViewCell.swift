//
//  AppointmentTableViewCell.swift
//  MyPracticeApp
//
//  Created by Welltime on 20/06/2016.
//  Copyright © 2016 Welltime. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {
    

    @IBOutlet weak var txt_appt_time: UILabel!
    @IBOutlet weak var txt_appt_duration: UILabel!
    @IBOutlet weak var txt_patient_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
