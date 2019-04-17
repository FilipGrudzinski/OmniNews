//
//  ArticleCell.swift
//  OmniNews
//
//  Created by Filip on 17/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class ArticlesAndTopicsCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleOrTopicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
