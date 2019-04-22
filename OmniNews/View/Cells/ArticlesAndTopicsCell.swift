//
//  ArticleCell.swift
//  OmniNews
//
//  Created by Filip on 17/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Kingfisher

class ArticlesAndTopicsCell: UITableViewCell {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleOrTopicLabel: UILabel!
    private let imageBaseUrl = "https://gfx-ios.omni.se/images/"
    
    func setupView(indexPath: IndexPath, segmentControlValue: Int, topics: [TopicModel], articles: [ArticleModel]) {
        if segmentControlValue == 0 {
            articleImage.isHidden = false
            let imageUrlID = articles[indexPath.row].articleImageID
            let resource = ImageResource(downloadURL: URL(string: "\(imageBaseUrl)\(imageUrlID)")!, cacheKey: "\(imageBaseUrl)\(imageUrlID)")
            articleImage.kf.setImage(with: resource)
            articleOrTopicLabel.text = articles[indexPath.row].articleTitle
        } else {
            articleImage.isHidden = true
            articleOrTopicLabel.text = topics[indexPath.row].topicTitle
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
    
    override func prepareForReuse() {
        articleImage.image = nil
        articleOrTopicLabel.text = ""
        
    }
    
}
