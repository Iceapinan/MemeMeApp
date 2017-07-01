//
//  ViewController.swift
//  MemeMeApp1.0
//
//  Created by IceApinan on 6/25/2560 BE.
//  Copyright © 2560 IceApinan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate
{
    @IBOutlet weak var myimageview: UIImageView!
    @IBOutlet weak var toptextfield: UITextField!
    @IBOutlet weak var bottomtextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    

    var memedImage = UIImage()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        toptextfield.delegate = self
        bottomtextfield.delegate = self
        
        // Setting font style and color
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: NSNumber(value:-3.0)] // Negative Values to fill the text
        
        
        
        toptextfield.defaultTextAttributes = memeTextAttributes
        bottomtextfield.defaultTextAttributes = memeTextAttributes
        
        // Text should be center-aligned.
        
        toptextfield.text = "TOP"
        bottomtextfield.text = "BOTTOM"
        toptextfield.textAlignment = NSTextAlignment.center
        bottomtextfield.textAlignment = NSTextAlignment.center
        toptextfield.delegate = self
        bottomtextfield.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    var memes = Meme()
    func save(image : UIImage) {
        // Create the meme
        let meme = Meme(topText: toptextfield.text!, bottomText: bottomtextfield.text!, originalImage: myimageview.image!, memedImage: memedImage)
        // Save Meme to "presistent storage" in AppDelegate :))
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! SentTableViewController
        self.present(TabBarController, animated: true, completion: nil)
        
        // Test
        print("SentTableViewController !!!")
        
    }
    
    // Combining image and text
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        self.toolBarTop.isHidden = true;
        self.toolBarBottom.isHidden = true;
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // TODO: Show toolbar and navbar
        self.toolBarTop.isHidden = false;
        self.toolBarBottom.isHidden = false;
        
        
        return memedImage
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    // When the keyboardWillShow notification is received, shift the view's frame up
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
   @objc func keyboardWillHide (_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @IBAction func CameraPressed(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func AlbumPressed(_ sender: Any)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myimageview.image = image
            myimageview.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // When a user taps inside a textfield, the default text should clear.
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // When a user presses return, the keyboard should be dismissed.
        textField.resignFirstResponder()
        return true
        
    }
    @IBAction func SharePressed (_ sender: Any) {
        let image = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
        
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}

