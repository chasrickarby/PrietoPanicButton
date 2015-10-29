//
//  SettingsViewController.swift
//  Prieto Panic Button
//
//  Created by Chas Rickarby on 7/16/15.
//  Copyright (c) 2015 Charles Rickarby. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

protocol SettingsViewControllerDelegate{
    func giveEverythingBack(yNumbers: [String], yNames: [String], yMessage: String, oNumbers: [String], oNames: [String], oMessage: String, rNumbers: [String], rNames: [String], rMessage: String)
}

class SettingsViewController: UIViewController, AddItemViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate {
    
    @IBOutlet weak var textField: UITextView!
    var textFieldData: [String] = []
    var phoneNumbers: [String] = []
    
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
            textField.text = yellowRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
            }
            break
        case 1:
            //Orange
            textView.text = orangeMessage
            textField.text = orangeRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
            }
            break
        case 2:
            //Red
            textView.text = redMessage
            textField.text = redRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
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
    var yellowRecipients: String = "Add recipients by clicking the add button to the right."
    
    var orangeNames: [String] = []
    var orangeNumbers: [String] = []
    var orangeMessage: String = "Enter Message Text Here."
    var orangeRecipients: String = "Add recipients by clicking the add button to the right."
    
    var redNames: [String] = []
    var redNumbers: [String] = []
    var redMessage: String = "Enter Message Text Here."
    var redRecipients: String = "Add recipients by clicking the add button to the right."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            textView.text = yellowMessage
            textField.text = yellowRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
            }
            break
        case 1:
            //Orange
            textView.text = orangeMessage
            textField.text = orangeRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
            }
            break
        case 2:
            //Red
            textView.text = redMessage
            textField.text = redRecipients
            if(textView.text.isEmpty){
                textView.text = "Enter Message Text Here."
            }
            if(textField.text.isEmpty){
                textField.text = "Add recipients by clicking the add button to the right."
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addContact(sender: UIButton) {
        let item = UIBarButtonItem()
        doPeoplePicker(item);
    }
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        if let delegate = self.delegate {
            delegate.giveEverythingBack(yellowNumbers, yNames: yellowNames, yMessage: yellowMessage, oNumbers: orangeNumbers, oNames: orangeNames, oMessage: orangeMessage, rNumbers: redNumbers, rNames: redNames, rMessage: redMessage)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);

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
    
    // MARK: - People Picker View Controller
    @IBAction func doPeoplePicker(sender: UIBarButtonItem) {
        
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [Int(kABPersonPhoneProperty)]
        // new iOS 8 features: instead of delegate "continueAfter" methods
        // picker.predicateForEnablingPerson = NSPredicate(format: "%K like %@", ABPersonFamilyNameProperty, "Neuburg")
        picker.predicateForSelectionOfPerson = NSPredicate(value:false) // display additional info for all persons
        picker.predicateForSelectionOfProperty = NSPredicate(value:true) // call delegate method for all properties
        self.presentViewController(picker, animated:true, completion:nil)
        
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
    }

    @IBAction func clearAll(sender: UIButton) {
        if(textField.text == "Add recipients by clicking the add button to the right."){
            return
        }
        textField.text = ""
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            yellowMessage = textView.text
            yellowRecipients = textField.text
            break
        case 1:
            //Orange
            orangeMessage = textView.text
            orangeRecipients = textField.text
            break
        case 2:
            //Red
            redMessage = textView.text
            redRecipients = textField.text
            break
        default:
            break
            
        }
    }
    
    
    @IBAction func saveData(sender: UIButton) {
        switch(codeSelector.selectedSegmentIndex){
        case 0:
            //Yellow
            yellowMessage = textView.text
            yellowRecipients = textField.text
            break
        case 1:
            //Orange
            orangeMessage = textView.text
            orangeRecipients = textField.text
            break
        case 2:
            //Red
            redMessage = textView.text
            redRecipients = textField.text
            break
        default:
            break
            
        }
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController,
        didSelectPerson person: ABRecordRef,
        property: ABPropertyID,
        identifier: ABMultiValueIdentifier) {
            
            if property != kABPersonPhoneProperty {
                print("WTF") // shouldn't happen
                return
            }
            let phoneNums:ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
            let ix = ABMultiValueGetIndexForIdentifier(phoneNums, identifier)
            let phone = ABMultiValueCopyValueAtIndex(phoneNums, ix).takeRetainedValue() as! String
            
            var personName = ABRecordCopyValue(person, kABPersonFirstNameProperty)
            let firstName: ABRecordRef = Unmanaged.fromOpaque(personName.toOpaque()).takeUnretainedValue() as NSString as ABRecordRef
            
            personName = ABRecordCopyValue(person, kABPersonLastNameProperty)
            let lastName: ABRecordRef = Unmanaged.fromOpaque(personName.toOpaque()).takeUnretainedValue() as NSString as ABRecordRef
            
            let fullName = (firstName as! String) + " " + (lastName as! String)
            
            // do something with the email here
            var bFound: Bool = false
            for value: String in (textFieldData){
                if(value == fullName){ //ALSO CHECK TO SEE IF PHONE NUMBER EXISTS... HANDLE THAT CASE AS WELL
                    bFound = true
                    break
                }
            }
            
            if(!bFound){
                textFieldData.append(fullName)
                phoneNumbers.append(phone)
                //for value: String in (textFieldData){
                if(textField.text == "Add recipients by clicking the add button to the right."){
                    textField.text = fullName
                }else{
                    textField.text = textField.text + "\n" + fullName
                }

            }
            
            switch(codeSelector.selectedSegmentIndex){
            case 0:
                //Yellow
                yellowMessage = textView.text
                yellowRecipients = textField.text
                break
            case 1:
                //Orange
                orangeMessage = textView.text
                orangeRecipients = textField.text
                break
            case 2:
                //Red
                redMessage = textView.text
                redRecipients = textField.text
                break
            default:
                break
                
            }
            
    }
    
}
