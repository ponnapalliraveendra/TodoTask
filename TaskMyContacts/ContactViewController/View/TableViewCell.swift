//
//  TableViewCell.swift
//  TaskMyContacts
//
//  Created by Surendra Ponnapalli on 04/01/20.
//  Copyright © 2019 Surendra Ponnapalli. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var descripLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var contactName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage.layer.cornerRadius = 31
        contactImage.clipsToBounds = true
        descripLbl.textColor = UIColor.black
        contactName.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
