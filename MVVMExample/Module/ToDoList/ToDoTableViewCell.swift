//
//  ToDoTableViewCell.swift
//  MVVMExample
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    var toDoListCellModel : ToDoListCellModel? {
        didSet {
            titleLabel.text = toDoListCellModel?.id.description
            descLabel.text = toDoListCellModel?.title
            stateImageView.image = toDoListCellModel?.completed ?? false ? #imageLiteral(resourceName: "baseline_done_outline") : #imageLiteral(resourceName: "baseline_schedule")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
