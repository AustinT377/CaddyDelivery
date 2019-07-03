//
//  UserModel.swift
//  Munchee
//
//  Created by Austin Turner on 7/3/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse

class UserModel: NSObject {
    
    
    func saveInstilationInformation(completion: ((Bool) -> ())? = nil) {
        let instilation = PFInstallation.current()
        let user = PFUser.current()
        instilation!["User"] = user
        instilation!["UserType"] = user?.object(forKey: "UserType") as! Int
        //        if sharedInfo.city != nil {
        //            instilation!["City"] = sharedInfo.city!
        //
        //        }
        
        instilation!.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                //print("instilation saved")
//                self.performSegue(withIdentifier: "newUserSegue", sender: self)
                completion!(true)
                // The object has been saved.
            }
            else {
                completion!(false)
                //print("instilation not saved")
                // There was a problem, check error.description
            }
        }
    }
    
    func getProfileImage(completion: ((UIImage?) -> ())? = nil) {
        
        let user = PFUser.current()
        
        if user!["profileImage"] == nil {
            completion!(nil)
        }
        else {
            //get image
            let thumbNail = user!["profileImage"] as! PFFileObject
            thumbNail.getDataInBackground {
                (imageData, error) -> Void in
                
                if (error == nil) {
                    
                    //if image is available
                    if imageData != nil {
                        let image = UIImage(data:imageData!)
                        completion!(image)
                        
                    }
                    
                }
                else {
                    completion!(nil)
                }
                
            }
        }
    }
    


}
