//
//  PostImageViewController.swift
//  InstagramClone
//
//  Created by Maria on 6/16/17.
//  Copyright © 2017 Maria Notohusodo. All rights reserved.
//

import UIKit

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imagePosted: UIImageView!
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let image = UIImagePickerController.init()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        imagePosted.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
    }
    
    func displayAlert(_ title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var message: UITextField!
    
    @IBAction func postImage(_ sender: UIButton) {
        activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.backgroundColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        let post = PFObject.init(className: "post")
        post["message"] = message.text
        post["userId"] = PFUser.current()?.objectId
        let imageData = UIImagePNGRepresentation(imagePosted.image!)
        let imageFile = PFFile.init(name: "image.png", data: imageData!)
        post["imageFile"] = imageFile
        post.saveInBackground { (success, error) in
            if error == nil {
                self.displayAlert("Image posted", message: "Your image has been posted successfully")
                self.imagePosted.image = UIImage.init(named: "user-silhouette.jpg")
                self.message.text = ""
            } else {
                self.displayAlert("Could not post image", message: "Please try again later")
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
