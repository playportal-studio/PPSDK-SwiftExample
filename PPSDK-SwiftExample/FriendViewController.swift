//
//  FriendViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/17/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import PPSDK_Swift
import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var friendProfiles = [PlayPortalProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
        
        loadFriendProfiles()
    }
    
    func loadFriendProfiles() {
        PlayPortalUser.shared.getFriendProfiles { [weak self] error, friendProfiles in
            guard let self = self else {
                return
            }
            if let error = error {
                print("Error occurred requesting friend profiles: \(error)")
            } else if let friendProfiles = friendProfiles {
                self.friendProfiles = friendProfiles
                self.tableView.reloadData()
            }
        }
    }
    
    func searchUsers(searchTerm: String) {
        //  Generally, it's a good idea to only allow search terms with 2 or more characters
        guard searchTerm.count >= 2 else {
            return
        }
        PlayPortalUser.shared.searchUsers(searchTerm: searchTerm) { [weak self] error, userProfiles in
            guard let self = self else {
                return
            }
            if let error = error {
                print("Error occurred requesting user search: \(error)")
            } else if let userProfiles = userProfiles {
                self.friendProfiles = userProfiles
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchRandomUsersTapped(_ sender: UIButton) {
        PlayPortalUser.shared.searchRandomUsers(count: 10) { [weak self] error, userProfiles in
            guard let self = self else {
                return
            }
            if let error = error {
                print("Error occurred requesting random users: \(error)")
            } else if let userProfiles = userProfiles {
                self.friendProfiles = userProfiles
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell") as? FriendTableViewCell else {
            fatalError("Could not dequeue FriendTableViewCell.")
        }
        let friendProfile = friendProfiles[indexPath.row]
        
        cell.handleLabel.text = friendProfile.handle
        cell.profilePicImageView.playPortalProfilePic(forImageId: friendProfile.profilePic) { error in
            if let error = error {
                print("Error requesting friend's profile pic: \(error)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadFriendProfiles()
        } else {
            searchUsers(searchTerm: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadFriendProfiles()
    }
}
