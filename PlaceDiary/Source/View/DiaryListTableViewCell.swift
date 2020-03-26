//
//  DiaryListTableViewCell.swift
//  PlaceDiary
//
//  Created by Fumiya Tanaka on 2020/03/26.
//

import UIKit

class DiaryListTableViewCell: UITableViewCell {
    @IBOutlet private weak var placeLabel: UILabel!
    
    var diary: Entity.Diary? {
        didSet {
            guard let diary = diary else {
                return
            }
            placeLabel.text = diary.place            
        }
    }
}
