//
//  SupportViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/16/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(menuBtn, statusBg: true, bg: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Open a new email
        openMail()
    }
    
    /* ==========================================
    *
    * MARK: MFMail Delegates
    *
    * =========================================== */
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if let error = error {
            // Inform the user there was an error sending the email
            let alert = UIAlertController(title: "Error", message: "Sorry, There Was An Error Processing Your Request", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(dismissBtn)
            presentViewController(alert, animated: true, completion: nil)
            print(error)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        self.revealViewController().revealToggleAnimated(true)
    }
    
    func openMail() {
        if MFMailComposeViewController.canSendMail() {
            dismissViewControllerAnimated(true, completion: nil)
            let sendEmail = MFMailComposeViewController()
            let email = "zachary1748@gmail.com"
            sendEmail.mailComposeDelegate = self
            sendEmail.setToRecipients([email])
            sendEmail.view.tintColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            sendEmail.setMessageBody("To whomever it may concern, \n\nI have a few questions I would like to ask: \n\n1. \n2. \n3. \n\nSincerely, \n\n(First Name) (Last Name) \n(123) 456-7890", isHTML: false)
            
            self.navigationController?.presentViewController(sendEmail, animated: true, completion: nil)
        } else {
            // Notify the user they need to configure their email
            let alert = UIAlertController(title: "Error", message: "Please Configure Your Email first, before submitting a support request.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(dismissBtn)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
