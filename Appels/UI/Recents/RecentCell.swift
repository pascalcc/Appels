//
//  RecentCell.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 10/11/2024.
//

import UIKit


class RecentCell: UITableViewCell {
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var hasTranscription: UIImageView!
            
    //FIX: custom font can't be set in storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        phoneNumber.font = UIFont(name: "IBMPlexSans-Regular", size: 17)!
        date.font = UIFont(name: "IBMPlexSans-Regular", size: 15)!
    }
    //FIX: custom font can't be set in storyboard

    func fillWith(_ call:Call) {
        phoneNumber.text = call.phoneNumber
        date.text = call.startedAt
        hasTranscription.isHidden = call.failed
        let imageName = switch (call.failed, call.incoming) {
            case (false, true): "incoming"
            case (false, false): "outgoing"
            default: "failure"
        }
        status.image = UIImage(named: imageName)
    }
        
}
