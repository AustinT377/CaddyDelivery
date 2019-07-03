//
//  Common.swift
//  Munchee
//
//  Created by Austin Turner on 7/2/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse

class Common: NSObject {
    
    
    func checkIfLoggedIn(window: UIWindow?, completion: ((Bool) -> ())? = nil) {
        let currentUser = PFUser.current()
        //if user is logged in
        if currentUser != nil {
            guard let userType = currentUser!["UserType"] as? Int else {return}

            //go to driver app
            if userType == 1 {
                let storyboard = UIStoryboard(name: "DriverStoryboard", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomePageTransition")
                
                window?.rootViewController = initialViewController
                window?.makeKeyAndVisible()
                completion?(true)
            }
            //go to user app
            else if userType == 0 {
                let storyboard = UIStoryboard(name: "UserMain", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                
                window?.rootViewController = initialViewController
                window?.makeKeyAndVisible()
                completion?(true)
            }
            else {
                let storyboard = UIStoryboard(name: "UserMain", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomePageTransition")
                
                window?.rootViewController = initialViewController
                window?.makeKeyAndVisible()
                completion?(true)
                
            }
        }
        else {
            completion?(false)
        }
    }
}

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        for (index, title) in actionTitles.enumerated() {
//            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
//            alert.addAction(action)
//        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func startLoading() {
        self.view.isUserInteractionEnabled = false
        
        LoadingIndicatorView.show("Loading")
    }
    
    func stopLoading() {
        
        self.view.isUserInteractionEnabled = true

        LoadingIndicatorView.hide()
    }
}
