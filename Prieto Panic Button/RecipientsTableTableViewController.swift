//
//  RecipientsTableTableViewController.swift
//  Prieto Panic Button
//
//  Created by Chas Rickarby on 8/11/15.
//  Copyright (c) 2015 Charles Rickarby. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

protocol AddItemViewControllerDelegate {
    func controller_names(controller: RecipientsTableTableViewController, contacts: [String])
    func controller_numbers(controller: RecipientsTableTableViewController, numbers: [String])
}

class RecipientsTableTableViewController: UITableViewController, ABPeoplePickerNavigationControllerDelegate {
    
    var tableData: [String] = []
    var phoneNumbers: [String] = []
    var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem();
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let delegate = self.delegate {
            delegate.controller_names(self, contacts: tableData)
            delegate.controller_numbers(self, numbers: phoneNumbers)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing) {
            // Add the + button
            self.navigationItem.leftBarButtonItem = nil;
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
            self.navigationItem.leftBarButtonItem = addButton;
            //println("Editing")
        } else {
            // remove the + button
            self.navigationItem.leftBarButtonItem = nil;
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
            self.navigationItem.leftBarButtonItem = doneButton;
            //println("Done")
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    @IBAction func add(sender: UIBarButtonItem){
        doPeoplePicker(sender)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = tableData[fromIndexPath.row]
        tableData.removeAtIndex(fromIndexPath.row)
        tableData.insert(itemToMove, atIndex: toIndexPath.row)
        
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
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
            for value: String in (tableData){
                if(value == fullName){ //ALSO CHECK TO SEE IF PHONE NUMBER EXISTS... HANDLE THAT CASE AS WELL
                    bFound = true
                    break
                }
            }
            
            if(!bFound){
                tableData.append(fullName)
                phoneNumbers.append(phone)
                self.tableView.reloadData()
            }
            
            
            
            
            // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
