//
//  MemeEditorViewController.swift
//  MemeMeApp
//
//  Created by Shirley Hang on 5/17/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set initial text
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
        
        //remove borders for the two text fields
        self.topText.borderStyle = UITextBorderStyle.None
        self.bottomText.borderStyle = UITextBorderStyle.None
        
        //set text attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0]
        
        //set text fields with the default meme text attributes
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        
        //set the text delegate
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        //center text
        self.topText.textAlignment = NSTextAlignment.Center
        self.bottomText.textAlignment = NSTextAlignment.Center
        
        //disable the share button until the image is selected
        shareButton.enabled = false
    }
    override func viewWillAppear(animated: Bool) {
        //disable the camera button if no camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //disable status bar
        UIApplication.sharedApplication().statusBarHidden = true
        
        //call to subscribe keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //call to unsubscribe keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    //subscribe notifications when keyboard appears and disappears
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //subscribe keyboard notifications when keyboard appears and disappears
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //slide up the frame if the bottom text is being entered
    func keyboardWillShow(notification: NSNotification)
    {
        if bottomText.editing
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //slide back to the original position when the bottom text is done editing
    func keyboardWillHide(notification: NSNotification)
    {
        if bottomText.editing
        {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //get the key board height to determine how much to slide up
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    //pick an image from the album
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let albumImagePicker = UIImagePickerController()
        
        albumImagePicker.delegate = self
        
        //set source from the album
        albumImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(albumImagePicker, animated: true, completion: nil)
    }
    //pick an image from the camera
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let cameraImagePicker = UIImagePickerController()
        
        cameraImagePicker.delegate = self
        
        cameraImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(cameraImagePicker, animated: true, completion: nil)
    }
    //an image has been selected from the picker, display the selected image in the meme editor
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //assign the selected image to the viewController
            self.imageView.image = image
            
            //set the content mode of the image to scaleAspectFit
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            //enable the share button
            shareButton.enabled = true
            
            //dismiss the image picker
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    //cancel the image selection, dismiss the picker controller
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //cancel the picking of the image on the editor view controller
    @IBAction func cancelPickImage(sender: AnyObject) {
        
        self.imageView.image = UIImage()
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
    }
    //dismiss keyboard when return key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //clear out the text fields when user taps inside a text field
    func textFieldDidBeginEditing(textField: UITextField) {
        //if user is entering text on the top text field, clear the top text field
        if self.topText.editing
        {
            self.topText.text = ""
        }
        
        //if user is entering text on the bottom text field, clear the bottom text field
        if self.bottomText.editing
        {
            self.bottomText.text = ""
        }
    }
    //create the Meme object
    func saveMeme()
    {
        //create the meme
        var meme = Meme(memeTopText: topText.text!, memeBottomText: bottomText.text!, memeOriginImage: imageView.image!, memedImage: generateMemedImage())
        
        //add to the memes array in the Application delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    //generate the combined text and image MemedImage
    func generateMemedImage() -> UIImage
    {
        //hide tool bars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let MemedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //reshow tool bars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        return MemedImage
    }
    
    //share button is clicked
    @IBAction func shareButtonEnable(sender: AnyObject) {
        //create a MemedImage that has the two text fields, and original image
        let generatedMemedImage = generateMemedImage()
        
        //present an activityViewController
        let actcViewController = UIActivityViewController(activityItems: [generatedMemedImage], applicationActivities: nil)
        
        self.presentViewController(actcViewController, animated: true, completion: nil)
        actcViewController.completionWithItemsHandler = processAfterSharing
    }
    //call to save the meme in an array for display
    func processAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!)
    {
        if completed
        {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    //cancel button goes to the sent Meme tab bar view controller
    @IBAction func cancelButton(sender: AnyObject)
    {
        var sentMemeTabBarcontroller: UITabBarController
        
        sentMemeTabBarcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
        
            self.presentViewController(sentMemeTabBarcontroller, animated: true, completion: nil)
    }
    
}
