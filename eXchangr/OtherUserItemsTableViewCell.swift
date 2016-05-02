//
//  OtherUserItemsTableViewCell.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 5/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class OtherUserItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
