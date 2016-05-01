//
//  DonateViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/16/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController, UIWebViewDelegate {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(menuBtn, statusBg: true, bg: true)

        // Set the default URL for the webview
        if let url = NSURL(string: "http://zgover.netau.net/donate.html") {
            webView.loadRequest(NSURLRequest(URL: url))
        }
        
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
