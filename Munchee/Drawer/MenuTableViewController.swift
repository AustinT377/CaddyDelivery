//
//  MenuTableViewController.swift
//  Munchee
//
//  Created by Austin Turner on 7/3/19.
//  Copyright © 2019 Austin Turner. All rights reserved.
//

import UIKit
import Parse
import FontAwesomeKit_Swift

class MenuTableViewController: UITableViewController {

    let iconDimensions = CGRect(x: 10, y: 10, width: 20, height: 25)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of cells to be created
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 5
        }
        else if section == 2 {
            return 2
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
            //color of segment
            returnedView.backgroundColor =  UIColor.gray
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        else {
            return 5.0
        }
    }
    
    /*
     override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     if indexPath.section == 0 && indexPath.row == 0 {
     return 48
     }
     else {
     return 44
     }
     }
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")!
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let user = PFUser.current()
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let image = UIImage(named: "default_profile")
                
//                if sharedInfo.profileImage != nil {
//                    image = sharedInfo.profileImage
//                }
                
                cell.imageView?.image = image
                
                
                cell.imageView?.layer.borderWidth = 1
                cell.imageView?.layer.masksToBounds = false
                cell.imageView?.layer.borderColor = UIColor.black.cgColor
                cell.imageView?.layer.cornerRadius = cell.frame.height/2
                cell.imageView?.clipsToBounds = true
                

                
                let firstName = user?.object(forKey: "firstName") as! String
                let lastName = user?.object(forKey: "lastName") as! String
                
                cell.textLabel?.text  = firstName + " " + lastName
                //"Profile"
                return cell
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let newImage = UIImage(awesomeType: .home, size: 30.00, textColor: .white)

                let cellImg : UIImageView = UIImageView(frame: iconDimensions)
                cellImg.image = newImage
                cell.addSubview(cellImg)
                
                cell.textLabel?.text  = "      Order"
                return cell
            }
            else if indexPath.row == 1 {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let newImage = UIImage(awesomeType: .history, size: 30.00, textColor: .white)

                let cellImg : UIImageView = UIImageView(frame: iconDimensions)
                cellImg.image = newImage
                cell.addSubview(cellImg)
                
                cell.textLabel?.text  = "      Order History"
                return cell
            }
            else if indexPath.row == 2 {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let newImage = UIImage(awesomeType: .comment, size: 30.00, textColor: .white)

                let cellImg : UIImageView = UIImageView(frame: iconDimensions)
                cellImg.image = newImage
                cell.addSubview(cellImg)
                
                cell.textLabel?.text  = "      Contact Us"
                return cell
            }
            else if indexPath.row == 3 {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApplicationCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let newImage = UIImage(awesomeType: .stickyNote, size: 30.00, textColor: .white)

                let cellImg : UIImageView = UIImageView(frame: iconDimensions)
                cellImg.image = newImage
                cell.addSubview(cellImg)
                
                cell.textLabel?.text  = "      Apply"
                return cell
            }
            else if indexPath.row == 4 {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "LogOutCell")!
                cell.textLabel?.textColor = UIColor.white
                
                let newImage = UIImage(awesomeType: .signOut, size: 30.00, textColor: .white)

                let cellImg : UIImageView = UIImageView(frame: iconDimensions)
                cellImg.image = newImage
                cell.addSubview(cellImg)
                
                cell.textLabel?.text  = "      Log Out"
                return cell
            }
            else {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")!
                cell.textLabel?.textColor = UIColor.white
                
                cell.textLabel?.text  = "Default Page"
                return cell
            }
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        sharedInfo.custRestaruant = nil
//
//        if (indexPath.row == 1 && indexPath.section == 1) || (indexPath.row == 3 && indexPath.section == 1) {
//            sharedInfo.fromHome = false
//
//        }
        
        //if user selects logout cell
        if indexPath.row == 3 && indexPath.section == 2 {
            PFUser.logOut()
            _ = PFUser.current()
        }
        //turn off click animation
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func reloadTable(_ notification: Notification){
        //load data here
        
        tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
