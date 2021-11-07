//
//  boardTableViewCell.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/05.
//

import UIKit

class boardTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
