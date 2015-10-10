//
//  ContentViewController.swift
//  Prieto Panic Button
//
//  Created by Chas Rickarby on 7/15/15.
//  Copyright (c) 2015 Charles Rickarby. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import AVKit
import MobileCoreServices
import AssetsLibrary

var _yellowRecipients: [String] = [""]
var _yellowMessage: String = ""

var _orangeRecipients: [String] = [""]
var _orangeMessage: String = ""

var _redRecipients: [String] = [""]
var _redMessage: String = ""

var m_bMessageSent = false;
var m_bCodeRed = false;

class ContentViewController: UIViewController, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var panicButton: UIButton!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    @IBAction func buttonPressed(sender: UIButton) {
        let titleLabel: UILabel? = sender.titleLabel
        let imageName: String = (titleLabel?.text)!
        
        switch(imageName){
        case "Yellow Panic Button":
            codeYellow()
            break
        case "Orange Panic Button":
            codeOrange()
            break
        case "Red Panic Button":
            codeRed()
            break
        default:
            break
        }
    }
    
    func codeYellow(){
        print("Yellow Button Press")
        //Create a new message body template with the info persisted from the
        //codeYellow info struct
        m_bCodeRed = false;
        sendText(_yellowMessage, nums: _yellowRecipients, codeRed: false)
    }
    
    func codeOrange(){
        print("Orange Button Press")
        //Create a new message body template with the info persisted from the
        //codeOrange info struct
        m_bCodeRed = false;
        sendText(_orangeMessage, nums: _orangeRecipients, codeRed: false)
    }
    
    func codeRed(){
        print("Red Button Press")
        //Create a new message body template with the info persisted from the
        //codeRed info struct
        m_bCodeRed = true;
        sendText(_redMessage, nums: _redRecipients, codeRed: true)
    }
    
    func recordVideo(){
        print("Try to record video")
        let ok = UIImagePickerController.isSourceTypeAvailable(.Camera)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeMovie as String
        // let desiredType = kUTTypeMovie
        let arr = UIImagePickerController.availableMediaTypesForSourceType(.Camera) as [String]!
        print(arr)
        if arr.indexOf(desiredType) == nil {
            print("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [desiredType]
        // picker.allowsEditing = true
        picker.delegate = self
        
        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        // better to get authorization beforehand
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: nil)
            return false
        case .Restricted:
            return false
        case .Denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .Default, handler: {
                    _ in
                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    
    
    func sendText(message: String, nums: [String], codeRed: Bool){
        if MFMessageComposeViewController.canSendText(){
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = message
            messageVC.recipients = nums
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: false, completion: nil)
            m_bMessageSent = true;
        }else{
            NSLog("your device does not support SMS....")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(m_bMessageSent && m_bCodeRed){
            recordVideo()
            m_bMessageSent = false;
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        let videoPath = info[UIImagePickerControllerMediaURL] as! NSURL
        
        ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(videoPath, completionBlock: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.panicButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.panicButton.setTitle(imageFile, forState: .Normal)
        
        self.panicButton.setImage(UIImage(named: imageFile), forState: .Normal)
        
        //self.imageView.image = UIImage(named: self.imageFile)
        //self.titleLabel.text = self.titleText
        //println(self.titleText);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
