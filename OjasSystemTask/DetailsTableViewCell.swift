//
//  DetailsTableViewCell.swift
//  OjasSystemTask
//
//  Created by Mouritech on 15/06/20.
//  Copyright © 2020 Mouritech. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    
    @IBOutlet weak var switchOperator: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
