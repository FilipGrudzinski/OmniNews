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

class ListScreenViewController: UIViewController {
    private let omniUrl = "https://omni-content.omni.news/search?query=" //Added https to avoide App Transport Security policy required the use of a secure connection
    private let cache = ImageCache.default
    var searchItem = ""
    private var articlesArray = [ArticleModel]()
    private var topicsArray = [TopicModel]()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var articlesTopicsSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(searchItem.capitalized) results"
        loadArticlesAndTopics()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cache.clearMemoryCache()
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
extension ListScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articlesTopicsSegment.selectedSegmentIndex == 0 {
            let counter = articlesArray.count
            return counter > 0 ? articlesArray.count : 1
        } else {
            let counter = topicsArray.count
            return counter > 0 ? topicsArray.count : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticlesAndTopicsCell
        if articlesArray.count > 0 || topicsArray.count > 0 {
            articlesTopicsSegment.isEnabled = true
            if articlesTopicsSegment.selectedSegmentIndex == 0 {
                cell.articleImage.isHidden = false
                let resource = ImageResource(downloadURL: URL(string: "http://gfx-ios.omni.se/images/\(articlesArray[indexPath.row].articleImageID)")!, cacheKey: "http://gfx-ios.omni.se/images/\(articlesArray[indexPath.row].articleImageID)")
                cell.articleImage.kf.setImage(with: resource)
                cell.articleOrTopicLabel.text = articlesArray[indexPath.row].articleTitle
            } else {
                cell.articleImage.isHidden = true
                cell.articleOrTopicLabel.text = topicsArray[indexPath.row].topicTitle
            }
        } else {
            articlesTopicsSegment.isEnabled = false
            cell.articleOrTopicLabel.text = "No Items Found"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return articlesTopicsSegment.selectedSegmentIndex == 0 ? 160 : 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let detailVC = segue.destination as! DetailViewController
            
            if articlesTopicsSegment.selectedSegmentIndex == 0 {
                let array = articlesArray[self.listTableView.indexPathForSelectedRow!.row].articlesMainText
                let joined = array.joined(separator: "\n\n")
                detailVC.detailText = joined
            } else {
                detailVC.detailText = topicsArray[self.listTableView.indexPathForSelectedRow!.row].topicType.capitalized
            }
        }
    }
}

//MARK: - Extension for Data request and Json save
extension ListScreenViewController {
    private func loadArticlesAndTopics() {
        SVProgressHUD.show(withStatus: "In Progress")
        Alamofire.request("\(omniUrl)\(searchItem)", method: .get).validate().responseJSON { response in
            if response.result.value != nil {
                let responseJSON: JSON = JSON(response.result.value!)
                self.savingJson(responseJSON)
                //print(responseJSON)
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func savingJson(_ json: JSON) {
        let topicsJSON = json["topics"]
        let articlesJSON = json["articles"]
        articlesJSON.array?.forEach({ (articles) in
            let counter = articles["main_text"]["paragraphs"].count
            var paragraphs = [String]()
            
            for n in 0..<counter {
                paragraphs.append(articles["main_text"]["paragraphs"][n]["text"]["value"].stringValue)
            }
            
            let article = ArticleModel(articleTitle: articles["title"]["value"].stringValue, articleImageID: articles["main_resource"]["image_asset"]["id"].stringValue, articlesMainText: paragraphs.self)
            articlesArray.append(article)
        })
        
        topicsJSON.array?.forEach({ (topics) in
            let topic = TopicModel(topicTitle: topics["title"].stringValue, topicType: topics["type"].stringValue)
            topicsArray.append(topic)
        })
        listTableView.reloadData()
    }
}

