//
//  FixStatusBar.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 11/11/2024.
//

import UIKit

class FixStatusBar : UINavigationController {

    override func viewDidLoad() {
        let d = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        d.fixStatusBar(inView: self.view)
    }
    
}
