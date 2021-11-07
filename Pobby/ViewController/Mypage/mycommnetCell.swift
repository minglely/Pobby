//
//  mycommnetCell.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/21.
//

import UIKit

class mycommnetCell: UITableViewCell {
    @IBOutlet weak var boardtitle: UILabel!
    @IBOutlet weak var mycomment: UILabel!
    @IBOutlet weak var commenttime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
