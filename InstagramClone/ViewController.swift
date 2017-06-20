//
//  ViewController.swift
//  InstagramClone
//
//  Created by Maria on 6/13/17.
//  Copyright © 2017 Maria Notohusodo. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    var signupActive = true
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var registeredText: UILabel!
    @IBOutlet weak var button2: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if username.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        } else {
            activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            var errorMessage = "Please try again later"
            if signupActive {
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackground { [weak self]
                    (succeeded, error) -> Void in
                    self?.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error == nil {
                        
                    } else {
                        if let errorString = error?.localizedDescription {
                            errorMessage = errorString
                        }
                        self?.displayAlert("Failed signup", message: errorMessage)
                    }
                }
            } else {
                PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { [weak self] (user, error) in
                    self?.activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    if user != nil {
                        self?.performSegue(withIdentifier: "login", sender: self)
                    } else {
                        if let errorString = error?.localizedDescription {
                            errorMessage = errorString
                        }
                        self?.displayAlert("Failed login", message: errorMessage)
                    }
                })
            }
            
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        if signupActive {
            button1.setTitle("Login", for: .normal)
            registeredText.text = "Not registered?"
            button2.setTitle("Sign Up", for: .normal)
            signupActive = false
            
        } else {
            button1.setTitle("Sign Up", for: .normal)
            registeredText.text = "Already registered?"
            button2.setTitle("Login", for: .normal)
            signupActive = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

