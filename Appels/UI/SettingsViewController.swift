//
//  ViewController.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 09/11/2024.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var load : SettingButton!
    @IBOutlet var clean : SettingButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPress(_ sender:SettingButton) {
        
        if sender == load {
            Model.loadAll()
            sender.isEnabled = false
            clean.isEnabled = true
        } else {
            Model.clean()
            sender.isEnabled = false
            load.isEnabled = true
        }
    }

}

