//
//  NotificationTableViewCell.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/22/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var notificationTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
