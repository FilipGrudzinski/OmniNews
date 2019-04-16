//
//  ViewController.swift
//  OmniNews
//
//  Created by Filip on 16/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class ListScreen: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - UITableViewDataSource
extension ListScreen: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListScreenCell

        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListScreen: UITableViewDelegate {
    // scroll view delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

