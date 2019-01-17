//
//  LoginViewController.swift
//  PPSDK-SwiftExample
//
//  Created by Lincoln Fraley on 1/3/19.
//  Copyright © 2019 Lincoln Fraley. All rights reserved.
//

import Foundation
import PPSDK_Swift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Add login button to handle SSO flow
        let loginButton = PlayPortalLoginButton(from: self)
        loginButton.center = CGPoint(x: loginView.bounds.size.width / 2, y: loginView.bounds.size.height / 2)
        loginView.addSubview(loginButton)
    }
}
