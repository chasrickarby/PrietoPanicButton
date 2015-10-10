//
//  ViewController.swift
//  Prieto Panic Button
//
//  Created by Chas Rickarby on 7/15/15.
//  Copyright (c) 2015 Charles Rickarby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, SettingsViewControllerDelegate {
    
    @IBOutlet weak var interiorView: UIView!
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    
    
    //DATA TO BE PERSISTED:
    var yNums: [String] = []
    var yContacts: [String] = []
    var yeMessage: String = ""
    var oNums: [String] = []
    var oContacts: [String] = []
    var orMessage: String = ""
    var rNums: [String] = []
    var rContacts: [String] = []
    var reMessage: String = ""
    
    let addressBook = APAddressBook()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pageTitles = NSArray(objects: "Code Yellow", "Code Orange", "Code Red")
        self.pageImages = NSArray(objects: "Yellow Panic Button", "Orange Panic Button", "Red Panic Button");
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 80, self.view.frame.width, self.view.frame.size.height - 80)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index: Int) -> ContentViewController{
        
        if(self.pageTitles.count == 0 || index >= self.pageTitles.count){
            return ContentViewController()
        }
        
        let vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.pageIndex = index
        
        return vc
        
    }    
    
    // MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func giveEverythingBack(yNumbers: [String], yNames: [String], yMessage: String, oNumbers: [String], oNames: [String], oMessage: String, rNumbers: [String], rNames: [String], rMessage: String) {
        yNums = yNumbers
        yContacts = yNames
        yeMessage = yMessage
        oNums = oNumbers
        oContacts = oNames
        orMessage = oMessage
        rNums = rNumbers
        rContacts = rNames
        reMessage = rMessage
        
        _yellowRecipients = yNums
        _yellowMessage = yeMessage
        
        _orangeRecipients = oNums
        _orangeMessage = orMessage
        
        _redRecipients = rNums
        _redMessage = reMessage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SettingsVC" {
            let SettingsVC = segue.destinationViewController as? SettingsViewController
            
            SettingsVC?.yellowNumbers = yNums
            SettingsVC?.yellowNames = yContacts
            SettingsVC?.yellowMessage = yeMessage
            SettingsVC?.orangeNumbers = oNums
            SettingsVC?.orangeNames = oContacts
            SettingsVC?.orangeMessage = orMessage
            SettingsVC?.redNumbers = rNums
            SettingsVC?.redNames = rContacts
            SettingsVC?.redMessage = reMessage
            
            
            if let viewController = SettingsVC {
                viewController.delegate = self
            }
            
        }

    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        
        if(index == NSNotFound){
            return nil
        }
        
        index++
        
        if(index == self.pageTitles.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }


}

