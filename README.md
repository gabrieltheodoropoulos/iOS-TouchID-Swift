# iOS-TouchID-Swift #

#### The TouchID authentication mechanism implemented in Swift ####


## About ##

In iOS 8, Apple provides a new framework named *LocalAuthentication* which lets us use the TouchID biometric authentication mechanism to our applications. TouchID was first introduced in iOS 7 as an alternative way to unlock iPhone 5s devices and make purchases in the App Store. Here I have created a "plug and play" class written in Swift, which you can add to your projects and integrate the TouchID authentication to your applications without performing any custom implementation at all, even without you need to know the TouchID details at all.

Normally, you don't have to do any modification to the TouchID class, unless you really need to. Read next to see instructions about its usage, and how easy it is to integrate it to your projects.


## How To Use ##

#### Add the class file to the project ####

The first step is to add the *TouchID.swift* file to your project. This file imports the *LocalAuthentication* framework, which the compiler should link automatically. However, if you encounter any problems, then go and add manually the *LocalAuthentication.framework* to your project.


#### Adopt the protocol ####

In the view controller that you are about to integrate the TouchID authentication, adopt the *TouchIDDelegate* protocol as shown next:

<code>class ViewController: UIViewController, TouchIDDelegate { ... }</code>


#### Initialize, setup and present ####

In the <code>viewDidLoad</code> method (or anywhere else that best suits you) initialize a TouchID object, set it up and make the proper call to present the TouchID dialog:

<pre><code>
// Initialize a TouchID object.
let touchIDAuth : TouchID = TouchID()

// Set the reason for which you ask authentication and that will appear to the TouchID dialog.
touchIDAuth.touchIDReasonString = "To access the app."

// Set your view controller class as the delegate of the TouchID class.
touchIDAuth.delegate = self

// Present the TouchID dialog.
touchIDAuth.touchIDAuthentication()
</code></pre>


#### Handling authentication results ####

There are two delegate methods you should necessarily implement. In case of successful authentication, the <code>touchIDAuthenticationWasSuccessful</code> delegate method is called, and in here you should add any code needed to proceed to the app and display its contents.

In case of unsuccessful authentication, then the <code>touchIDAuthenticationFailed</code> delegate method is called. Its parameter, an *enum* value, describes the reason for which the authentication failed. Use a <code>switch</code> or an <code>if</code> statement to go through all possible cases and take the proper actions for each one of them. Pay special attention to the case where the user fallbacks to a custom authentication method. For all the possible fail/error reasons, either take a look at the *TouchIDErrorCode* enum in the *TouchID.swift* file, or look up the *LAError* class in the official documentation.


## Remarks ##

Take a quick look at the sample project for a reference on how to use it. It won't take you more than two minutes, and it's a necessary step so as you see everything that I previously described in action.

Remember that you can't test the TouchID authentication in Simulator, you need a real device.
