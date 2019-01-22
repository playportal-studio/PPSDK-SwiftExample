//
//  LeaderboardViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/21/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import UIKit
import PPSDK_Swift

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addScoreTextField: UITextField!
    @IBOutlet weak var addCategoriesTextField: UITextField!
    @IBOutlet weak var readCategoriesTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var leaderboardEntries = [PlayPortalLeaderboardEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        readLeaderboardEntries([])
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let score = addScoreTextField.text.flatMap(Double.init) else {
            return
        }
        var categories = [String]()
        if let c = addCategoriesTextField.text?.split(separator: ",").map(String.init) {
            categories = c
        }
        print(categories)
        PlayPortalLeaderboard.shared.updateLeaderboard(score, forCategories: categories) { [weak self] error, _ in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred updating leaderboard: \(error)")
            } else {
                self.readLeaderboardEntries(categories)
            }
        }
    }
    
    @IBAction func readTapped(_ sender: UIButton) {
        var categories = [String]()
        if let c = readCategoriesTextField.text?.split(separator: ",").map(String.init) {
            categories = c
        }
        readLeaderboardEntries(categories)
    }
    
    func readLeaderboardEntries(_ categories: [String]) {
        PlayPortalLeaderboard.shared.getLeaderboard(forCategories: categories) { [weak self] error, leaderboardEntries in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred reading leaderboard: \(error)")
            } else if let leaderboardEntries = leaderboardEntries {
                print("Read leaderboard!")
                self.leaderboardEntries = leaderboardEntries
                self.tableView.reloadData()
            } else {
                print("Unknown error occurred")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardTableViewCell") as? LeaderboardTableViewCell else {
            fatalError("Could not dequeue LeaderboardTableViewCell.")
        }
        let entry = leaderboardEntries[indexPath.row]
        
        cell.rankLabel.text = String(entry.rank)
        cell.scoreLabel.text = String(entry.score)
        
        cell.profilePicImageView.playPortalProfilePic(forImageId: entry.user.profilePic) { error in
            if let error = error {
                print("Error occurred requesting profile pic: \(error)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
