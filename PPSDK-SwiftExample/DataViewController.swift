//
//  DataViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/17/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import UIKit
import PPSDK_Swift

class DataViewController: UIViewController {
    
    //  Create
    @IBOutlet weak var createBucketTextField: UITextField!
    
    //  Read
    @IBOutlet weak var readBucketNameTextField: UITextField!
    @IBOutlet weak var readKeyTextField: UITextField!
    @IBOutlet weak var valueAtKeyLabel: UILabel!
    
    //  Write
    @IBOutlet weak var writeBucketNameTextField: UITextField!
    @IBOutlet weak var writeKeyTextField: UITextField!
    @IBOutlet weak var writeValueTextField: UITextField!
    
    //  Delete key
    @IBOutlet weak var deleteKeyBucketNameTextField: UITextField!
    @IBOutlet weak var deleteKeyTextField: UITextField!
    
    //  Delete bucket
    @IBOutlet weak var deleteBucketNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createBucketTapped(_ sender: UIButton) {
        guard let bucketName = createBucketTextField.text, bucketName.count > 0 else {
            return
        }
        PlayPortalData.shared.create(bucketNamed: bucketName) { error in
            if let error = error {
                print("Error occurred creating bucket: \(error)")
            } else {
                print("Created bucket \"\(bucketName)\"!")
            }
        }
    }
    
    @IBAction func readFromBucketTapped(_ sender: UIButton) {
        guard let bucketName = readBucketNameTextField.text
            , let key = readKeyTextField.text else {
                return
        }
        PlayPortalData.shared.read(fromBucket: bucketName, atKey: key) { [weak self] error, data in
            guard let self = self else { return }
            if let error = error {
                print("Error occurred reading from bucket \"\(bucketName)\" at key \"\(key)\": \(error)")
            } else if let data = data as? String {
                print("Read data from bucket!")
                self.valueAtKeyLabel.text = data
            } else {
                print("Key \"\(key)\" not found in bucket \"\(bucketName)\".")
            }
        }
    }
    
    @IBAction func writeToBucketTapped(_ sender: UIButton) {
        guard let bucketName = writeBucketNameTextField.text
            , let key = writeKeyTextField.text
            , let value = writeValueTextField.text else {
                return
        }
        PlayPortalData.shared.write(toBucket: bucketName, atKey: key, withValue: value) { error, data in
            if let error = error {
                print("Error occurred writing to bucket \"\(bucketName)\" at key \"\(key)\" with value \"\(value)\": \(error)")
            } else {
                print("Wrote value to bucket!")
                print(data)
            }
        }
    }
    
    @IBAction func deleteKeyInBucketTapped(_ sender: UIButton) {
        guard let bucketName = deleteKeyBucketNameTextField.text
            , let key = deleteKeyTextField.text else {
                return
        }
        PlayPortalData.shared.delete(fromBucket: bucketName, atKey: key) { error, bucket in
            if let error = error {
                print("Error occurred deleting key \"\(key)\" from bucket \"\(bucketName)\": \(error)")
            } else {
                print("Deleted key from bucket!")
                print(bucket)
            }
        }
    }
    
    @IBAction func deleteBucketTapped(_ sender: UIButton) {
        guard let bucketName = deleteBucketNameTextField.text else {
            return
        }
        PlayPortalData.shared.delete(bucketNamed: bucketName) { error in
            if let error = error {
                print("Error occurred deleting bucket bucket \"\(bucketName)\": \(error)")
            } else {
                print("Deleted bucket!")
            }
        }
    }
}
