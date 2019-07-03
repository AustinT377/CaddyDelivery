//
//  CreateAccountViewController.swift
//  Munchee
//
//  Created by Austin Turner on 7/2/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {
    
    var userModel: UserModel = UserModel()

    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.createAccountSelected()

    }
    
    @IBAction func createAccountButton(_ sender: AnyObject) {
        
        self.createAccountSelected()
    }
    
    func createAccountSelected() {
        self.startLoading()
        
        self.removeWhiteSpaces()
        if self.checkEmpty() {
            createUser()
        }
        else {
            self.stopLoading()
        }
    }
    
    func removeWhiteSpaces() {
        firstNameTextField.text = firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        lastNameTextField.text = lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        usernameTextField.text = usernameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
        
//        password1TextField.text = password1TextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
//        password2TextField.text = password2TextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        emailTextField.text = emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
    }
    
    func checkEmpty() -> Bool {
        
        if (firstNameTextField.text!.isEmpty) {

            self.errorMessage(title: "Error", message: "Please enter first name")
            return false
        }
        else if (lastNameTextField.text!.isEmpty) {
            self.errorMessage(title: "Error", message: "Please enter last name")
            return false

        }
        else if (usernameTextField.text!.isEmpty) {
            
            self.errorMessage(title: "Error", message: "Please enter a username")
            return false

        }
        else if phoneNumberTextField.text!.isEmpty {
            self.errorMessage(title: "Error", message: "please enter a phone number")
            return false

        }
        else if password1TextField.text!  == "" || password1TextField.text!  == " " {
            self.errorMessage(title: "Error", message: "Please enter a password")
            return false

        }
        else if password2TextField.text!  == "" || password2TextField.text!  == " " {
            self.errorMessage(title: "Error", message: "Please confirm password")
            return false

        }
        else if password1TextField.text!  != password2TextField.text! {
            self.errorMessage(title: "Error", message: "Passwords do not match")
            return false

        }
        else {
            return true
        }
        

    }
    
    func errorMessage(title: String, message: String) {
        
        self.popupAlert(title: title, message: message, actionTitles: ["OK"])
    }

        

    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField {
            usernameTextField.becomeFirstResponder()
            
        }
        else if textField == usernameTextField {
            phoneNumberTextField.becomeFirstResponder()
            
        }
        else if textField == phoneNumberTextField {
            emailTextField.becomeFirstResponder()
            
        }
        else if textField == emailTextField {
            password1TextField.becomeFirstResponder()
            
        }
        else if textField == password1TextField {
            password2TextField.becomeFirstResponder()
            
        }
        else {
            startLoading()

        }
        return true
    }
    
    
    
    func createUser() {
        
        let email = self.emailTextField.text
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        let username = self.usernameTextField.text
        let password = self.password1TextField.text
        let phoneNumber = self.phoneNumberTextField.text
        
        //create user object
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        // other fields can be set just like with PFObject
        user["phone"] = phoneNumber
        user["firstName"] = firstName
        user["lastName"] = lastName
        user["UserType"] = 0
//        if sharedInfo.city != nil {
//            user["City"] = sharedInfo.city!
//
//        }
        
        user.signUpInBackground {
            (succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                self.createParseAccount()
            }
            else {
                self.errorMessage(title: "Error", message: error!.localizedDescription)
                self.stopLoading()
            }
        }
    }
    
    func createParseAccount() {
        let user: PFUser = PFUser.current()!
        
        //creates stripe user account
        PFCloud.callFunction(inBackground: "createCustomer", withParameters: ["email": user.email!, "name": user.username!, "objectId": user.objectId!, "updated" : true]) {
            (response: Any?, error: Error?) -> Void in
            //let responseString = response as? String
            if error == nil {
                
                //login to account
                PFUser.logInWithUsername(inBackground: self.usernameTextField.text!.lowercased() ,password: self.password1TextField.text!) {
                    (user, error) -> Void in
                    if user != nil {
                        //check username and password
                        let userInfo = PFObject(className:"UserInfo")
                        userInfo["username"] = self.usernameTextField.text!.lowercased()
                        userInfo["password"] = self.password1TextField.text!
                        userInfo.pinInBackground()
                        
                        self.userModel.saveInstilationInformation() { [] complete in
                            
                            self.performSegue(withIdentifier: "newUserSegue", sender: self)

                        }
                        
                        // Do stuff after successful login.
                        
                    }
                    else {
                        let alertController = UIAlertController(title: "Error", message:
                            error?.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
                        self.stopLoading()
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
                //stripe account not created
            else {
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
                self.stopLoading()
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
//    func saveInstilationInformation() {
//        let instilation = PFInstallation.current()
//        let user = PFUser.current()
//        instilation!["User"] = user
//        instilation!["UserType"] = user?.object(forKey: "UserType") as! Int
////        if sharedInfo.city != nil {
////            instilation!["City"] = sharedInfo.city!
////
////        }
//
//        instilation!.saveInBackground {
//            (success: Bool, error: Error?) -> Void in
//            if (success) {
//                //print("instilation saved")
//                self.performSegue(withIdentifier: "newUserSegue", sender: self)
//
//                // The object has been saved.
//            }
//            else {
//                //print("instilation not saved")
//                // There was a problem, check error.description
//            }
//        }
//    }
    
    
    
//    func startLoading() {
//
//        self.view.isUserInteractionEnabled = false
//
//        LoadingIndicatorView.show("Loading")
//
//
//    }
//
//    func stopLoading() {
//
//        self.view.isUserInteractionEnabled = true
//
//        LoadingIndicatorView.hide()
//
//
//    }
    
    
    @objc func keyboardDoneButtonTapped() {
        //print("keyboard done button tapped")
        
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        keyboardToolbar.barStyle = UIBarStyle.default
        
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateAccountViewController.keyboardDoneButtonTapped))]
        
        keyboardToolbar.sizeToFit()
        emailTextField.inputAccessoryView = keyboardToolbar
        usernameTextField.inputAccessoryView = keyboardToolbar
        lastNameTextField.inputAccessoryView = keyboardToolbar
        password1TextField.inputAccessoryView = keyboardToolbar
        password2TextField.inputAccessoryView = keyboardToolbar
        firstNameTextField.inputAccessoryView = keyboardToolbar
        lastNameTextField.inputAccessoryView = keyboardToolbar
        phoneNumberTextField.inputAccessoryView = keyboardToolbar
        
        
        scrollView.keyboardDismissMode = .onDrag
        
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
