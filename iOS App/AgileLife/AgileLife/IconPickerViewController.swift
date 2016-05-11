//
//  IconPickerCollectionViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 5/10/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private let reuseIdentifier = "iconCell"

class IconPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var iconCellectionView: UICollectionView!
    
    /* ==========================================
    *
    * MARK: Global Properties
    *
    * =========================================== */
    
    var selectedIcon:String!
    var delegate:ViewDelegates!
    var allImages:[String]!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)
        self.title = "Choose Icon"
        
        allImages = [
            "check-square", "edit-square", "hourglass", "users"
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ==========================================
    *
    * MARK: Navigation
    *
    * =========================================== */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // }
    
    
    /* ==========================================
    *
    * MARK: UICollectionViewDataSource
    *
    * =========================================== */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? IconCollectionViewCell {
            
            cell.imageView.image = UIImage(named: allImages[indexPath.row])
            
            return cell
            
        }
        
        // Configure the cell
        
        return UICollectionViewCell()
    }
    
    /* ==========================================
    *
    * MARK: UICollectionViewDelegate
    *
    * =========================================== */
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    // override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    // return true
    // }
    
    // Uncomment this method to specify if the specified item should be selected
    // override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    // return true
    // }
    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    // override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    // return false
    // }
    
//    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//        return true
//    }
//    
//    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
//        print("hello")
//        delegate.selectedIcon!(allImages[indexPath.row])
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate.selectedIcon!(allImages[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}
