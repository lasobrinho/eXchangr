//
//  EditItemViewController.swift
//  eXchangr
//
//  Created by Lucas Alves Sobrinho on 4/22/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func BackButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddItemButtonTapped(sender: AnyObject) {
        // Code to add/edit a new item
    }
    
}
