//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var missionNameLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureReasonLabel: UILabel!
    @IBOutlet weak var missionPatchImageView: UIImageView!
    
    private let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale =  Locale.init(identifier: formatter.locale.identifier)
        formatter.timeZone = TimeZone.current

        return formatter
    }()
    
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale =  Locale.init(identifier: formatter.locale.identifier)
        formatter.timeZone = TimeZone.current

        return formatter
    }()
    
    func configure(with launch: Launch) {
        missionNameLabel.text = launch.name
        
        if let launchDate = inputDateFormatter.date(from: launch.dateLocal) {
            launchDateLabel.text = displayDateFormatter.string(from: launchDate)
        } else {
            launchDateLabel.text = "Invalid date"
        }
        
        
        if let success = launch.success {
            if success {
                successLabel.text = "Success"
                successLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1) // Bright Green
                failureReasonLabel.isHidden = true
            } else {
                successLabel.text = "Failed"
                successLabel.textColor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1) // Bright Red
                if let firstFailure = launch.failures.first {
                    failureReasonLabel.text = "Failure Reason: \(firstFailure.reason)"
                    failureReasonLabel.isHidden = false
                } else {
                    failureReasonLabel.isHidden = true
                }
            }
        } else {
            successLabel.text = "Unknown"
            successLabel.textColor = .lightGray
            failureReasonLabel.isHidden = true
        }
 
        // Load the mission patch image using SDWebImage
        if let imageUrlString = launch.links.patch?.small, let imageUrl = URL(string: imageUrlString) {
            missionPatchImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        } else {
            missionPatchImageView.image = UIImage(named: "placeholder") // Placeholder image if no URL is available
        }
    }
}
