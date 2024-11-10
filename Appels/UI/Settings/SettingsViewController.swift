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
        
        load.isEnabled = allCalls.calls.isEmpty
        clean.isEnabled = !load.isEnabled
    }

    
    @IBAction func delayedLoading() {
        CallModel.loadAll(withDelay: true)
        
        load.isEnabled = false
        clean.isEnabled = true
    }
    
    @IBAction func onPress(_ sender:SettingButton) {
        sender.isEnabled = false
        if sender == load {
            CallModel.loadAll()
            clean.isEnabled = true
        } else {
            CallModel.clean()
            load.isEnabled = true
        }
    }

}

