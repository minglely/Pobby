//
//  LoadingCellTableViewCell.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/05.
//

import UIKit

class LoadingCellTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        activityIndicator.color = UIColor.white
    }


    
}
