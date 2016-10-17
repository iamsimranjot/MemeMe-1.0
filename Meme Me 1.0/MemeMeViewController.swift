//
//  MemeMeViewController.swift
//  Meme Me 1.0
//
//  Created by SimranJot Singh on 04/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //IBoutlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Constants
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0
        ] as [String : Any]
    
    
    let TOP_TEXTFIELD_DEFAULT_TEXT = "TOP"
    let BOTTOM_TEXTFIELD_DEFAULT_TEXT = "BOTTOM"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setTextFields(textField: topTextField, string: TOP_TEXTFIELD_DEFAULT_TEXT)
        setTextFields(textField: bottomTextField, string: BOTTOM_TEXTFIELD_DEFAULT_TEXT)
        scrollView.delegate = self;
        scrollView.backgroundColor = UIColor.black
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // if there's an image in the imageView, enable the share button
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        
        //To enable or disable camera bar button if camera is available for use or not
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func resetTextfieldText(){
        
        topTextField.text = TOP_TEXTFIELD_DEFAULT_TEXT
        bottomTextField.text = BOTTOM_TEXTFIELD_DEFAULT_TEXT
    }
    
    
    // MARK: UIImagePickerController Functions
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        //To pick an image from Photos Albums
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion:nil)
        
    }
    
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        // To take a image directly from camera
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerController Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // To select an image and set it to imageView
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePickerView.image = image
            setZoomScaleForImage(scrollViewSize: scrollView.bounds.size)
            scrollView.zoomScale = scrollView.minimumZoomScale
            centerImage()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // To dismiss imagePicker when cancel button is clicked
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: Notification Funtions
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Keyboard Related Methods and Delegates
    
    func keyboardWillShow(notification: NSNotification) {
        //setting frame of view when keyboard shows
        
        if bottomTextField.isFirstResponder && self.view.frame.origin.y == 0 {
            
            self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
    }
    

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //getting height of keyboard for setting view's frame accordingly
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    
    // MARK: Generating Meme Objects 
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    
    func save(memedImage: UIImage) {

        let meme = Meme(topText: topTextField.text! as NSString!, bottomText: bottomTextField.text! as NSString!,  image: imagePickerView.image, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as!
            AppDelegate).memes.append(meme)
    }
    
    
    @IBAction func shareAction(_ sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                
                //save the image
                self.save(memedImage: memedImage)
                
                //Dismiss the shareActivityViewController
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        
        if topTextField.isFirstResponder {
            
            topTextField.resignFirstResponder()
            
        }else if bottomTextField.isFirstResponder {
            
            bottomTextField.resignFirstResponder()
        }
        
        imagePickerView.image = nil
        resetTextfieldText()
        shareButton.isEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    override func viewWillLayoutSubviews() {
        
        setZoomScaleForImage(scrollViewSize: scrollView.bounds.size)
        
        if scrollView.zoomScale < scrollView.minimumZoomScale || scrollView.zoomScale == 1{
            
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        
        centerImage()
        
    }
    
}


extension MemeMeViewController: UITextFieldDelegate {
    
    func setTextFields(textField: UITextField, string: String) {
        
        //set textview's default behaviour
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = string
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self;
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Erase the default text when editing
        if textField == topTextField && textField.text == TOP_TEXTFIELD_DEFAULT_TEXT {
            
            textField.text = ""
            
        } else if textField == bottomTextField && textField.text == BOTTOM_TEXTFIELD_DEFAULT_TEXT {
            
            textField.text = ""
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text as NSString?
        text = text!.replacingCharacters(in: range, with: string) as NSString?
        
        //to ensure capitalization works even if someone pastes text
        textField.text = text?.uppercased
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Allows the user to use the return key to hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //To set default text if textfields text is empty
        if textField == topTextField && textField.text!.isEmpty {
            
            textField.text = TOP_TEXTFIELD_DEFAULT_TEXT;
            
        }else if textField == bottomTextField && textField.text!.isEmpty {
            
            textField.text = BOTTOM_TEXTFIELD_DEFAULT_TEXT;
        }
    }
}


extension MemeMeViewController: UIScrollViewDelegate {
    
    func setZoomScaleForImage(scrollViewSize: CGSize) {
        
        if let image = imagePickerView.image {
            
            let imageSize = image.size
            
            let widthScale = scrollViewSize.width / imageSize.width
            let heightScale = scrollViewSize.height / imageSize.height
            
            //this will help for both potrait and landscape oriented images
            let minScale = min(widthScale, heightScale)
            
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    func centerImage() {
        
        if let image = imagePickerView.image {
            
            let scrollViewSize = scrollView.bounds.size
            let imageSize = image.size
            
            let horizontalSpace = imageSize.width * scrollView.zoomScale < scrollViewSize.width ? (scrollViewSize.width - imageSize.width * scrollView.zoomScale) / 2 : 0
            let verticalSpace = imageSize.height * scrollView.zoomScale < scrollViewSize.height ? (scrollViewSize.height - imageSize.height * scrollView.zoomScale) / 2 : 0
            
            scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
       return imagePickerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        centerImage()
    }
}
