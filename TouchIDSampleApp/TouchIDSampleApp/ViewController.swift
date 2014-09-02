//
//  ViewController.swift
//  TouchIDSampleApp
//
//  Created by Gabriel Theodoropoulos.
//  Copyright (c) 2014 Gabriel Theodoropoulos. All rights reserved.
//
//  E-mail:     gabrielth.devel@gmail.com
//  Website:    http://gtiapps.com
//  Google+:    http://plus.google.com/+GabrielTheodoropoulos
//

import UIKit

class ViewController: UIViewController, TouchIDDelegate {
    
    @IBOutlet weak var lblMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let touchIDAuth : TouchID = TouchID()
        touchIDAuth.touchIDReasonString = "To access the app."
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: TouchIDDelegate method implementation
    
    func touchIDAuthenticationWasSuccessful() {
        // TODO: Proceed to the app and show its contents after a successful login.
        
        self.lblMessage.text = "Successful Authentication!"
    }
    
    
    func touchIDAuthenticationFailed(errorCode: TouchIDErrorCode) {
        // TODO: Fallback to a custom authentication method when necessary.
        
        switch errorCode{
        case .TouchID_CanceledByTheSystem:
            self.lblMessage.text = "Canceled by the system"
            
        case .TouchID_CanceledByTheUser:
            self.lblMessage.text = "Canceled by the user"
            
        case .TouchID_PasscodeNotSet:
            self.lblMessage.text = "No passcode was set"
            
        case .TouchID_TouchIDNotAvailable:
            self.lblMessage.text = "TouchID is not available"
            
        case .TouchID_TouchIDNotEnrolled:
            self.lblMessage.text = "No enrolled finger was found"
            
        case .TouchID_UserFallback:
            self.lblMessage.text = "Should call custom authentication method"
            
        default:
            self.lblMessage.text = "Authentication failed"
        }
    }
}

