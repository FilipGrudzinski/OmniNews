//
//  MainViewController.swift
//  OmniNews
//
//  Created by Filip on 17/04/2019.
//  Copyright © 2019 Filip. All rights reserved.
//

import UIKit

class MainViewController: UIViewController  {
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if !searchTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            performSegue(withIdentifier: "goToListScreen", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListScreen" {
            let secondVC = segue.destination as! ListScreen
            secondVC.searchItem = searchTextField.text!
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
