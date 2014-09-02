//
//  TouchID.swift
//
//  Created by Gabriel Theodoropoulos.
//  Copyright (c) 2014 Gabriel Theodoropoulos. All rights reserved.
//
//  E-mail:     gabrielth.devel@gmail.com
//  Website:    http://gtiapps.com
//  Google+:    http://plus.google.com/+GabrielTheodoropoulos
//

import UIKit
import LocalAuthentication


enum TouchIDErrorCode {
    case TouchID_AuthenticationFailed   // When the authentication fails (e.g. wrong finger)
    case TouchID_PasscodeNotSet         // No passcode was set in the device's Settings
    case TouchID_CanceledByTheSystem    // The system cancels the authentication because another app became active
    case TouchID_TouchIDNotAvailable    // The TouchID authentication mechanism is not supported by the device
    case TouchID_TouchIDNotEnrolled     // The TouchID authentication is supported but no finger was enrolled
    case TouchID_CanceledByTheUser      // The user cancels the authentication
    case TouchID_UserFallback           // The user selects to fall back to a custom authentication method
}


protocol TouchIDDelegate{
    
    func touchIDAuthenticationWasSuccessful();
    
    func touchIDAuthenticationFailed(var errorCode: TouchIDErrorCode);
}


class TouchID: NSObject {
   
    var delegate : TouchIDDelegate!
    
    var touchIDReasonString : String?
    
    
    func touchIDAuthentication(){
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access this application."
        if let reason = touchIDReasonString {
            reasonString = reason
        }
        
        // Declare and initialize a custom error variable to represent a LocalAuthentication error (LAError).
        var customErrorCode : TouchIDErrorCode?
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    // This is the case of a successful authentication.
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate.touchIDAuthenticationWasSuccessful()
                    })
                }
                else{
                    // This is the case of a failed authentication.
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.toRaw():
                        customErrorCode = .TouchID_CanceledByTheSystem
                        
                    case LAError.UserCancel.toRaw():
                        customErrorCode = .TouchID_CanceledByTheUser
                        
                    case LAError.UserFallback.toRaw():
                        customErrorCode = .TouchID_UserFallback
                        
                    default:
                        customErrorCode = .TouchID_AuthenticationFailed
                    }
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate.touchIDAuthenticationFailed(customErrorCode!)
                    })
                }
            })]
        }
        else{
            // The policy cannot be evaluated.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.toRaw():
                customErrorCode = .TouchID_TouchIDNotEnrolled
                
            case LAError.PasscodeNotSet.toRaw():
                customErrorCode = .TouchID_PasscodeNotSet
                
            default:
                customErrorCode = .TouchID_TouchIDNotAvailable
            }
            
            
            delegate.touchIDAuthenticationFailed(customErrorCode!)
        }
    }
    
}
