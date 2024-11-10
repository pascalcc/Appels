//
//  CustomButton.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 09/11/2024.
//

import UIKit

@IBDesignable class SettingButton: UIButton {
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
                        
        layer.addSublayer(border)
        layer.cornerRadius = 10
        layer.masksToBounds = true
                
        setTitleColor(Colors.SettingsButton.disabledFont, for: .disabled)
        setTitleColor(Colors.SettingsButton.enabledFont, for: .normal)
    }
    
    private let border = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        border.lineWidth = 1.0
        border.frame = bounds
        border.fillColor = (isEnabled ? Colors.SettingsButton.enabledBackground : Colors.SettingsButton.disabledBackground).cgColor
        border.strokeColor = (isEnabled ? .clear : Colors.SettingsButton.disabledBorder).cgColor
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    
}


