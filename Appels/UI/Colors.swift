//
//  Colors.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 09/11/2024.
//


import UIKit
import SwiftUI

struct Colors {
        
    static let enabledFont = UIColor(red: 19.0/255.0, green: 56.0/255.0, blue: 59.0/255.0, alpha: 1)
    static let disabledFont = UIColor(red: 97.0/255.0, green: 109.0/255.0, blue: 112.0/255.0, alpha: 1)
    
    struct SettingsButton {
        static let enabledBackground = UIColor(named: "MainColor")!
        static let disabledBackground = UIColor.clear
        static let disabledBorder = UIColor(red: 188.0/255.0, green: 197.0/255.0, blue: 200.0/255.0, alpha: 1)
    }
    
    struct Transcription {                
        static let advertBackground = Color("App", bundle: nil)
        static let advert = Color(uiColor: disabledFont)

        static let mineBorder = advertBackground
        static let mineText = Color(uiColor: enabledFont)
        
        static let otherBackground = Color(red: 214.0/255.0, green: 250.0/255.0, blue: 242.0/255.0)
        static let otherText = Color(red: 2.0/255.0, green: 117.0/255.0, blue: 98.0/255.0)
    }
}
