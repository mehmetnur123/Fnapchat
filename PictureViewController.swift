//
//  PictureViewController.swift
//  Fnapchat
//
//  Created by Mehmet Nur on 09.07.17.
//  Copyright © 2017 Mehmet Nur. All rights reserved.
//

import UIKit
import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        nextButton.isEnabled = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        cameraPressed(imageView)
    }

    @IBAction func cameraPressed(_ sender: Any) {
        print("TARGET OS: \(TARGET_OS_SIMULATOR)")
        if(TARGET_OS_SIMULATOR == 1){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        if(imageView.image != nil){
            
            nextButton.isEnabled = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        let imagesFolder = Storage.storage().reference().child("images")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.05)
        
        nextButton.isEnabled = false
        
        imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imageData!, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("ERROR PICTURE UPLOAD")
            } else {
                print("PICTURE UPLOAD SUCCEEDED: \(metadata?.downloadURL())")
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let nextVC = segue.destination as! selectUserViewController
          nextVC.imageURL = sender as! String
          nextVC.descrip = descriptionTextField.text!
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
