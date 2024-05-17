//
//  LaunchDetailViewController.swift
//  SpaceX
//
//  Created by Amarnath B on 16/05/24.
//  Copyright © 2024 Amarnath B. All rights reserved.
//

import UIKit
import SDWebImage

class LaunchDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureReasonLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var backBtn: UIButton!
    
    var launch: Launch?
    
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
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let launch = launch {
            configureView(with: launch)
        }
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // This method is called when the gesture recognizer attempts to begin a gesture
        // You can add custom logic here if needed
        return true
    }
    
    func configureView(with launch: Launch) {
        nameLabel.text = launch.name
        if let launchDate = inputDateFormatter.date(from: launch.dateLocal) {
            dateLabel.text = "Date: \(displayDateFormatter.string(from: launchDate))"  
        } else {
            dateLabel.text = "Date: Unknown Date" // Placeholder for invalid dates
        }
        successLabel.text = launch.success == true ? "Success" : "Failed"
        
        // Update the text color based on success or failure
        if launch.success == true {
            successLabel.text = "Success"
            successLabel.textColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1) // Bright Green
            failureReasonLabel.isHidden = true
        } else {
            successLabel.text = "Failed"
            successLabel.textColor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1) // Bright Red
            if let firstFailure = launch.failures.first {
                failureReasonLabel.text = "Failure Reason: \(firstFailure.reason)"
                failureReasonLabel.isHidden = false // Ensure the label is visible
            } else {
                failureReasonLabel.isHidden = true // Hide the label if there is no failure reason
            }
        }
        
        
        rocketLabel.text = "Rocket: \(launch.rocket)"
        if let imageUrlString = launch.links.patch?.large, let imageUrl = URL(string: imageUrlString) {
            imageView.load(url: imageUrl)
        }
    }
}


extension UIImageView {
    func load(url: URL) {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}
