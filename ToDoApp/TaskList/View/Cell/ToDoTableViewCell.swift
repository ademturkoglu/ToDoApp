//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 25.05.2021.
//

import Foundation
import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    func configure(with model: Task?) {
        titleLabel.text = model?.title
       // dateLabel.text = model.dat
        if let date = model?.dueDate {
            dateLabel.text = date.toString(format: .full)
        }else{
            dateLabel.text = "-"
        }
        switch model?.state {
        case .done:
            stateImageView.image = UIImage(named: "done")
        default:
            stateImageView.image = UIImage(named: "todo")
        }
        
    }
    
    
}
