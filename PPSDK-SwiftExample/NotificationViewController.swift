//
//  NotificationViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/22/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import UIKit
import PPSDK_Swift

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var notificationTextTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userProfile: PlayPortalProfile!
    var notifications = [PlayPortalNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        guard let notificationText = notificationTextTextField.text else {
            return
        }
        let receiver = receiverTextField.text != nil && receiverTextField.text!.count > 0
            ? receiverTextField.text!
            : userProfile.userId
        
        PlayPortalNotifications.shared.createNotification(text: notificationText, receiver: receiver) { error in
            if let error = error {
                print("Error occurred creating notification: \(error)")
            } else {
                print("Created notification!")
            }
        }
    }
    
    @IBAction func readTapped(_ sender: UIButton) {
        readNotifications()
    }
    
    func readNotifications() {
        PlayPortalNotifications.shared.readNotifications(acknowledged: false) { [weak self] error, notifications in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred reading notifications: \(error)")
            } else if let notifications = notifications {
                print("Read notifications!")
                self.notifications = notifications
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableViewCell") as? NotificationTableViewCell else {
            fatalError("Could not dequeue NotificationTableViewCell.")
        }
        let notification = notifications[indexPath.row]
        
        cell.handleLabel.text = notification.sender
        cell.notificationTextLabel.text = notification.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        let notification = notifications[indexPath.row]
        PlayPortalNotifications.shared.acknowledgeNotification(notificationId: notification.notificationId) { error in
            if let error = error {
                print("Error occurred acknowledging notification: \(error)")
            } else {
                print("Acknowledged notification!")
                self.readNotifications()
            }
        }
    }
}
