//
//  SettingsViewController.swift
//  Prieto Panic Button
//
//  Created by Chas Rickarby on 7/16/15.
//  Copyright (c) 2015 Charles Rickarby. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate{
    func giveEverythingBack(yNumbers: [String], yNames: [String], yMessage: String, oNumbers: [String], oNames: [String], oMessage: String, rNumbers: [String], rNames: [String], rMessage: String)
}

class SettingsViewController: UIViewController, AddItemViewControllerDelegate {
    
    @IBOutlet weak var codeSelector: UISegmentedControl!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func saveMessage(sender: UIButton) {
        textView.endEditing(true)
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            yellowMessage = textView.text
            print("yellowMessage " + yellowMessage)
            break
        case 1:
            //Orange
            orangeMessage = textView.text
            print("orangeMessage " + orangeMessage)
            break
        case 2:
            //Red
            redMessage = textView.text
            print("redMessage " + yellowMessage)
            break
        default:
            break
            
        }

    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            textView.text = yellowMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        case 1:
            //Orange
            textView.text = orangeMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        case 2:
            //Red
            textView.text = redMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        default:
            break
            
        }
        
    }
    
    var delegate: SettingsViewControllerDelegate?
    
    var yellowNames: [String] = []
    var yellowNumbers: [String] = []
    var yellowMessage: String = "Enter Message Text Here."
    
    var orangeNames: [String] = []
    var orangeNumbers: [String] = []
    var orangeMessage: String = "Enter Message Text Here."
    
    var redNames: [String] = []
    var redNumbers: [String] = []
    var redMessage: String = "Enter Message Text Here."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            textView.text = yellowMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        case 1:
            //Orange
            textView.text = orangeMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        case 2:
            //Red
            textView.text = redMessage
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            break
        default:
            break
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func controller_numbers(controller: RecipientsTableTableViewController, numbers: [String]) {
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            yellowNumbers = numbers
            break
        case 1:
            //Orange
            orangeNumbers = numbers
            break
        case 2:
            //Red
            redNumbers = numbers
            break
        default:
            break
        }
        //self.numbers = numbers
    }
    
    func controller_names(controller: RecipientsTableTableViewController, contacts: [String]) {
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            yellowNames = contacts
            break
        case 1:
            //Orange
            orangeNames = contacts
            break
        case 2:
            //Red
            redNames = contacts
            break
        default:
            break
        }
        //self.names = contacts
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        if let delegate = self.delegate {
            delegate.giveEverythingBack(yellowNumbers, yNames: yellowNames, yMessage: yellowMessage, oNumbers: orangeNumbers, oNames: orangeNames, oMessage: orangeMessage, rNumbers: redNumbers, rNames: redNames, rMessage: redMessage)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
        /*
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            println(yellowNames)
            println(yellowNumbers)
            break
        case 1:
            println(orangeNames)
            println(orangeNumbers)
            break
        case 2:
            println(redNames)
            println(redNumbers)
            break
        default:
            break
        }
*/
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RecipientsTableVC" {
            let navigationController = segue.destinationViewController as? UINavigationController
            let addItemViewController = navigationController?.topViewController as? RecipientsTableTableViewController
            
            switch(codeSelector.selectedSegmentIndex){
            case 0:
                addItemViewController?.tableData = yellowNames
                addItemViewController?.phoneNumbers = yellowNumbers
                break
            case 1:
                addItemViewController?.tableData = orangeNames
                addItemViewController?.phoneNumbers = orangeNumbers
                break
            case 2:
                addItemViewController?.tableData = redNames
                addItemViewController?.phoneNumbers = redNumbers
                break
            default:
                break
            }
            
            if let viewController = addItemViewController {
                viewController.delegate = self
            }
        }
    }
    
}
