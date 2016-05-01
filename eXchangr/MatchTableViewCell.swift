//
//  MatchTableViewCell.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var leftItemImage: UIImageView!
    @IBOutlet weak var leftItemNameLabel: UILabel!
    @IBOutlet weak var rightItemImage: UIImageView!
    @IBOutlet weak var rightItemNameLabel: UILabel!
    @IBOutlet weak var rightItemLocationLabel: UILabel!
    @IBOutlet weak var rightItemDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
