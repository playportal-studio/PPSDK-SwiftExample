//
//  ProfileViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/3/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import UIKit
import PPSDK_Swift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    var userProfile: PlayPortalProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func openPlayPortalTapped(_ sender: UIButton) {
        PlayPortalUtils.openOrDownloadPlayPORTAL(from: self)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        PlayPortalAuth.shared.logout()
    }
    
    func setupView() {
        nameLabel.text = userProfile.handle
        if let firstName = userProfile.firstName, let lastName = userProfile.lastName {
            nameLabel.text = nameLabel.text ?? nameLabel.text! + " | " + firstName + " " + lastName
        }
        accountTypeLabel.text = userProfile.accountType.rawValue
        userTypeLabel.text = userProfile.userType.rawValue
        coverPhotoImageView.playPortalCoverPhoto(forImageId: userProfile.coverPhoto) { error in
            if let error = error {
                print("Error requesting cover photo: \(String(describing: error))")
            }
        }
        profilePicImageView.playPortalProfilePic(forImageId: userProfile.profilePic) { error in
            if let error = error {
                print("Error requesting profile pic: \(String(describing: error))")
            }
        }
    }
}
