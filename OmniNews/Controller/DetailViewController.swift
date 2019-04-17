//
//  DetailViewController.swift
//  OmniNews
//
//  Created by Filip on 18/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailTextView: UITextView!
    var detailText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        detailTextView.text = detailText
    }
}
