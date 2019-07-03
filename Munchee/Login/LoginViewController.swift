//
//  LoginViewController.swift
//  Munchee
//
//  Created by Austin Turner on 7/3/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    let userModel: UserModel = UserModel()
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var termsOfService: UIButton!
    @IBOutlet weak var disclaimer: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgotPasswordAttributes: UIButton!
    @IBOutlet weak var signInButtonAttributes: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createAccountAttributes: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var driverLoginButton: UIButton!
    
    @IBAction func driverSignIn
        (_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "DriverStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DriverLogin") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tapBackground(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signInButton(_ sender: AnyObject) {
        self.loginUser()
    }
    
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        
        let alertController = UIAlertController(
            title: "Email",
            message: "Please enter your email",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
        title: "Submit", style: .default) {
            (action) -> Void in
            
            let email = (alertController.textFields?.first?.text?.lowercased())!
            //print(email)
            self.submitForgotPassword(email)
            
        }
        let cancelAction = UIAlertAction(
        title: "Cancel", style: .cancel) {
            (action) -> Void in
            
            
        }
        alertController.addTextField {
            (txtEmail) -> Void in
            txtEmail.placeholder = "Email Address"
            txtEmail.keyboardType = UIKeyboardType.emailAddress
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func submitForgotPassword(_ email: String) {
        //check email
        
        //submit email
        PFUser.requestPasswordResetForEmail(inBackground: email)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("Textfield began editing")
        
        scrollView.isScrollEnabled = true
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenWidth == 320 && screenHeight == 480 {
            //iphone 4
            self.scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
            
        }
        else {
            self.scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("Textfield did end editing")
        
        scrollView.isScrollEnabled = false
        
        self.scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            self.loginUser()
        }
        return true
    }
    
    func loginUser() {
        self.view.endEditing(true)
        
        usernameTextField.text = usernameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
        
        passwordTextField.text = passwordTextField.text!
        
        
        
        self.startLoading()
        
        //login to account
        PFUser.logInWithUsername(inBackground: usernameTextField.text!.lowercased(), password: passwordTextField.text!) {
            (user, error) -> Void in
            if user != nil {
                //check username and password
                let userInfo = PFObject(className:"UserInfo")
                userInfo["username"] = self.usernameTextField.text!.lowercased()
                userInfo["password"] = self.passwordTextField.text!
                userInfo.pinInBackground()
                
                
                //print("User found")
                self.userModel.saveInstilationInformation() { [] complete in
                    
                    self.stopLoading()
                    self.performSegue(withIdentifier: "LoggedIn", sender: self)
                    
                }
                
            }
                //if login failed
            else {
                
                self.stopLoading()
                self.popupAlert(title: "Error", message: error?.localizedDescription, actionTitles: ["OK"])
                
                self.passwordTextField.text! = ""
            }
        }

    }
    
    
    override func viewDidLoad() {

        //moveButtons()
        scrollView.keyboardDismissMode = .onDrag
        
        signInButtonAttributes.layer.cornerRadius = signInButtonAttributes.frame.size.width/80
        signInButtonAttributes.clipsToBounds = true
        
        createAccountAttributes.layer.cornerRadius = createAccountAttributes.frame.size.width/80
        createAccountAttributes.clipsToBounds = true
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
