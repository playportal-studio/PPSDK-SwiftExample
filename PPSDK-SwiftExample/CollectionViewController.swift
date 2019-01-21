//
//  CollectionViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/18/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import UIKit
import PPSDK_Swift

struct Score: Codable {
    
    let id: Int
    let score: Int
    
    init(id: Int) {
        self.id = id
        self.score = Int.random(in: 0...100)
    }
}

extension Score: Equatable {
    
    static func ==(lhs: Score, rhs: Score) -> Bool {
        return lhs.id == rhs.id
    }
}

class CollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var createTextField: UITextField!
    @IBOutlet weak var readTextField: UITextField!
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var removeTextField: UITextField!
    @IBOutlet weak var updateTextField: UITextField!
    @IBOutlet weak var deleteTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentCollection = [Score]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        guard let collectionName = createTextField.text else {
            return
        }
        PlayPortalCollection.shared.create(collectionNamed: collectionName) { error in
            if let error = error {
                print("Error occurred creating collection \"\(collectionName)\": \(error)")
            } else {
                print("Created collection \"\(collectionName)\"!")
            }
        }
    }
    
    @IBAction func readTapped(_ sender: UIButton) {
        guard let collectionName = readTextField.text else {
            return
        }
        PlayPortalCollection.shared.read(fromCollection: collectionName) { [weak self] (error: Error?, collection: [Score]?) in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred reading from collection \"\(collectionName)\": \(error)")
            } else if let collection = collection {
                print("Read from \"\(collectionName)\"!")
                self.currentCollection = collection.sorted { $0.id < $1.id }
                self.tableView.reloadData()
            } else {
                print("Unknown error occurred!")
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let collectionName = addTextField.text else {
            return
        }
        let score = currentCollection.last != nil
            ? Score(id: currentCollection.last!.id + 1)
            : Score(id: 1)
        PlayPortalCollection.shared.add(toCollection: collectionName, element: score) { [weak self] error, collection in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred adding item to collection \"\(collectionName)\": \(error)")
            } else if let collection = collection {
                print("Added item to \"\(collectionName)\"!")
                self.currentCollection = collection.sorted { $0.id < $1.id }
                self.tableView.reloadData()
            } else {
                print("Unknown error occurred!")
            }
        }
    }
    
    @IBAction func removeTapped(_ sender: UIButton) {
        guard let collectionName = removeTextField.text, currentCollection.count > 0 else {
            return
        }
        let randomScore = currentCollection.randomElement()!
        PlayPortalCollection.shared.remove(fromCollection: collectionName, value: randomScore) { [weak self] error, collection in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred removing item from collection \"\(collectionName)\": \(error)")
            } else if let collection = collection {
                print("Removed item from \"\(collectionName)\"!")
                self.currentCollection = collection.sorted { $0.id < $1.id }
                self.tableView.reloadData()
            } else {
                print("Unknown error occurred!")
            }
        }
    }
    
    @IBAction func updateTapped(_ sender: UIButton) {
        guard let collectionName = updateTextField.text, currentCollection.count > 0 else {
            return
        }
        let oldScore = currentCollection[Int.random(in: 0..<currentCollection.count)]
        let newScore = Score(id: oldScore.id)
        PlayPortalCollection.shared.update(inCollection: collectionName, oldValue: oldScore, newValue: newScore) { [weak self] error, collection in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred updating item in collection \"\(collectionName)\": \(error)")
            } else if let collection = collection {
                print("Updated item in \"\(collectionName)\"!")
                self.currentCollection = collection.sorted { $0.id < $1.id }
                self.tableView.reloadData()
            } else {
                print("Unknown error occurred!")
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard let collectionName = deleteTextField.text else {
            return
        }
        PlayPortalCollection.shared.delete(collectionNamed: collectionName) { error in
            if let error = error {
                print("Error deleting collection \"\(collectionName)\": \(error)")
            } else {
                print("Deleted \"\(collectionName)\"!")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "collectionTableViewCell") as? CollectionTableViewCell else {
            fatalError("Could not dequeue CollectionTableViewCell.")
        }
        let score = currentCollection[indexPath.row]
        
        cell.idLabel.text = String(score.id)
        cell.scoreLabel.text = String(score.score)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
