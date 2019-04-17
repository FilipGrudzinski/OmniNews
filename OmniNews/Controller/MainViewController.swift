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
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextField.text = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if !searchTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            performSegue(withIdentifier: "goToListScreen", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListScreen" {
            let secondVC = segue.destination as! ListScreen
            secondVC.searchItem = searchTextField.text!.trimmingCharacters(in: .whitespaces)
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
