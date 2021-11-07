//
//  ticketingDetailVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/19.
//

import UIKit

class ticketingDetailVC: UIViewController {
    
    var ticket : ticket_schedule?

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewset()
    }
    
    func viewset() {
        mainView.sendSubviewToBack(backView)
        backgroundImage.image = ticket?.photo
        backgroundImage.alpha = 0.5
        posterImage.image = ticket?.photo
        
        titleLabel.text = ticket?.title
        
        timeLabel.layer.borderWidth = 1
        timeLabel.layer.borderColor = CGColor.init(red: 144/255, green: 91/255, blue: 238/255, alpha: 1.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let day = dateFormatter.string(from:ticket?.time ?? Date())
        dateFormatter.dateFormat = "hh:mm a"
        let time =  dateFormatter.string(from:ticket?.time ?? Date())
        timeLabel.text = "티켓오픈 \(day) \(time)"
        
        detailText.text = ticket?.detail

    }

}
