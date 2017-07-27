//
//  MemeEditorViewController.swift
//  MemeMeApp
//
//  Created by IceApinan on 6/25/2017 BE.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var myimageview: UIImageView!
    @IBOutlet weak var toptextfield: UITextField!
    @IBOutlet weak var bottomtextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setting font style and color
        
        configure(textField: toptextfield, withText: "TOP")
        configure(textField: bottomtextfield, withText: "BOTTOM")
        
    }
    
    func configure (textField: UITextField, withText: String) {
        let memeTextAttributes:[String:Any] = [NSStrokeColorAttributeName : UIColor.black, NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: NSNumber(value:-3.0)]
        textField.text = withText
        textField.defaultTextAttributes = memeTextAttributes
        // Text should be center-aligned.
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
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
    
    func setToolBarHidden (_ value : Bool) {
        toolBarTop.isHidden = value
        toolBarBottom.isHidden = value
        
    }
    
    // Combining image and text
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        setToolBarHidden(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // TODO: Show toolbar and navbar
        setToolBarHidden(false)
        
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
        if bottomtextfield.isFirstResponder == true
        {
            view.frame.origin.y = -getKeyboardHeight(notification)

        }
    }
    @objc func keyboardWillHide (_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func imageSourcePressed(_ sender: Any)
    {
        let button = sender as! UIBarButtonItem
        if button.tag == 0 {
        chooseSourceType(sourceType: .camera)
        } else {
        chooseSourceType(sourceType: .photoLibrary)
        }
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
            shareButton.isEnabled = true
        }
        picker.delegate = self
        dismiss(animated: true, completion: nil)
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
    func save(image : UIImage) {
        // Create the meme
        let meme = Meme(topText: toptextfield.text!, bottomText: bottomtextfield.text!, originalImage: image, memedImage: generateMemedImage())
        // Save it to AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}

// MARK : UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // When a user taps inside a textfield, the default text should clear.
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // When a user presses return, the keyboard should be dismissed.
        textField.resignFirstResponder()
        return true
        
    }
    
}

