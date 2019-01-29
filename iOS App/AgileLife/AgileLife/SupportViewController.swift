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
        openMail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ==========================================
    *
    * MARK: MFMail Delegates
    *
    * =========================================== */
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            // Inform the user there was an error sending the email
            let alert = UIAlertController(title: "Error", message: "Sorry, There Was An Error Processing Your Request", preferredStyle: UIAlertControllerStyle.alert)
            let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(dismissBtn)
            present(alert, animated: true, completion: nil)
            print("Mail Error: \(error)")
        } else {
            dismiss(animated: true, completion: nil)
            self.navigationItem.hidesBackButton = true
            self.view.isUserInteractionEnabled = false
            self.menuBtn.isEnabled = false
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    func openMail() {
        // If the user has their email setup allow them to open the mail controller.
        if MFMailComposeViewController.canSendMail() {
            dismiss(animated: true, completion: nil)
            let sendEmail = MFMailComposeViewController()
            let email = "zachary1748@gmail.com"
            sendEmail.mailComposeDelegate = self
            sendEmail.setToRecipients([email])
            sendEmail.view.tintColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            sendEmail.setMessageBody("To whomever it may concern, \n\nI have a few questions I would like to ask: \n\n1. \n2. \n3. \n\nSincerely, \n\n(First Name) (Last Name) \n(123) 456-7890", isHTML: false)
            
            self.navigationController?.present(sendEmail, animated: true, completion: nil)
        } else {
            // Notify the user they need to configure their email
            let alert = UIAlertController(title: "Warning", message: "Please Configure Your Email first, before submitting a support request.", preferredStyle: UIAlertControllerStyle.alert)
            let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(dismissBtn)
            present(alert, animated: true, completion: nil)
        }
    }
}
