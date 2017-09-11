//
//  ListCell.swift
//  GetACook
//
//  Created by Jonathan on 07/06/2017.
//
//

import UIKit

class ListCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chiefPhoto: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    var stars = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        stars += [star1, star2, star3, star4, star5]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
