//
//  TermsOfServiceViewController.swift
//  Munchee
//
//  Created by Austin Turner on 7/3/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse

class TermsOfServiceViewController: UIViewController {

    var terms: String = ""

    @IBOutlet weak var termsTextView: UITextView!
    
    
    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData(){
        
        termsTextView.text = self.terms
        
        self.stopLoading()
    }
    
    func loadTerms() {
        let query = PFQuery(className: "Terms")
        
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as [PFObject]? {
                    for object in objects {
                        
                        self.terms = object.object(forKey: "Terms") as! String
                        self.loadData()
                        
                    }
                }
            }
            else {
                // Log details of the failure
                //print("Error: \(String(describing: error)) \(error!.localizedDescription)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        self.startLoading()
        
        self.loadTerms()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
