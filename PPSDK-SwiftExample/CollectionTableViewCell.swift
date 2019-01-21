//
//  CollectionTableViewCell.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/18/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
