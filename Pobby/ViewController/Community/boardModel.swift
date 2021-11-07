//
//  boardModel.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/19.
//

import Foundation
import UIKit


struct Board {    
    var category: String?
    var userID: String?
    var title: String?
    var photo: String?
    var contents: String?
    var view : Int?
    var date : Date?
    
    struct comment: Codable {
        var contents : String?
        var userID : String?
        var date : Date?
        
        enum CodingKeys: String, CodingKey {
            case contents
            case userID
            case date
        }
    }
    
    var comments : [comment]
}
