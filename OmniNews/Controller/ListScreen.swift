//
//  ViewController.swift
//  OmniNews
//
//  Created by Filip on 16/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Kingfisher

class ListScreen: UIViewController {
    private let omniUrl = "https://omni-content.omni.news/search?query=stockholm" //Added https to avoide App Transport Security policy required the use of a secure connection
    var searchItem = ""
    private var articlesArray = [ArticleModel]()
    private var topicsArray = [TopicModel]()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var articlesTopicsSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArticlesAndTopics()
    }
    
    @IBAction func articlesTopicsSegmentControl(_ sender: UISegmentedControl) {
        switch articlesTopicsSegment.selectedSegmentIndex {
        case 0:
            listTableView.reloadData()
        case 1:
            listTableView.reloadData()
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension ListScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articlesTopicsSegment.selectedSegmentIndex == 0 {
            return articlesArray.count
        } else {
            return topicsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticlesAndTopicsCell
        if articlesTopicsSegment.selectedSegmentIndex == 0 {
            cell.articleImage.isHidden = false
            cell.typeTopicLabel.isHidden = true
            cell.articleOrTopicLabel.text = articlesArray[indexPath.row].articleTitle
            let resource = ImageResource(downloadURL: URL(string: "https://gfx-ios.omni.se/images/\(articlesArray[indexPath.row].articleImageID)")!, cacheKey: "https://gfx-ios.omni.se/images/\(articlesArray[indexPath.row].articleImageID)")
            cell.articleImage.kf.setImage(with: resource)
        } else {
            cell.articleImage.isHidden = true
            cell.typeTopicLabel.isHidden = false
            cell.articleOrTopicLabel.text = topicsArray[indexPath.row].topicTitle
            cell.typeTopicLabel.text = topicsArray[indexPath.row].topicType.capitalized
        }
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if articlesTopicsSegment.selectedSegmentIndex == 0 {
            return 160
        } else {
            return 60
        }
    }
}

//MARK: - Extension for Data request and Json save
extension ListScreen {
    private func loadArticlesAndTopics() {
        SVProgressHUD.show(withStatus: "In Progress")
        Alamofire.request(omniUrl, method: .get).validate().responseJSON { response in
            if response.result.value != nil {
                let responseJSON: JSON = JSON(response.result.value!)
                self.savingJson(responseJSON)
                
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func savingJson(_ json: JSON) {
        let topicsJSON = json["topics"]
        let articlesJSON = json["articles"]
        
        articlesJSON.array?.forEach({ (articles) in
            let article = ArticleModel(articleTitle: articles["title"]["value"].stringValue, articleImageID: articles["main_resource"]["image_asset"]["id"].stringValue)
            articlesArray.append(article)
        })
        
        topicsJSON.array?.forEach({ (topics) in
            let topic = TopicModel(topicTitle: topics["title"].stringValue, topicType: topics["type"].stringValue)
            topicsArray.append(topic)
        })
        
        SVProgressHUD.dismiss()
        listTableView.reloadData()
    }
}
