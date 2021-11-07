//
//  TableViewCell.swift
//  LoadMoreExample
//
//  Created by John Codeos on 10/14/2019.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import UIKit

class TableViewItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
