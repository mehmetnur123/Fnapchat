//
//  SignInViewController.swift
//  Fnapchat
//
//  Created by Mehmet Nur on 06.07.17.
//  Copyright © 2017 Mehmet Nur. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerInfo: UILabel!
    @IBOutlet weak var turnUpButton: UIButton!
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func turnUpTapped(_ sender: Any) {
        turnUpButton.isEnabled = false
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if(error != nil){
                print("not signed in - ERROR: \(error)");
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("TRIED to create user");
                    if(error != nil){
                        print("error in CREATE USER: \(error)");
                        
                        self.registerInfo.text = "Invalid password!"
                        self.registerInfo.textColor = UIColor.red
                        self.registerInfo.isHidden = false
                        self.turnUpButton.isEnabled = true
                    }else{
                        let users = Database.database().reference().child("users")
                        users.child(user!.uid).child("mail").setValue(user!.email!)
                        self.registerInfo.text = "Account not found on Server --> New Account has been created succesfully!"
                        self.registerInfo.textColor = UIColor.green
                        self.registerInfo.isHidden = false
                        self.registerInfo.isHidden = false
                        self.turnUpButton.isEnabled = true
                        self.uid = user!.uid
                        self.createWelcomeFnap()
                        self.turnUpButton.isEnabled = true
                        print("USER CREATED SUCCESSFULLY!")
                    }
                })
            }else{
                self.registerInfo.isHidden = true
                self.turnUpButton.isEnabled = true
                self.performSegue(withIdentifier: "signInSeugue", sender: nil)
            }
        };
    }
    
    func createWelcomeFnap(){
        let snap = ["from":"mehmet@fnapchat.de", "description": "Welcome to Fnapchat!", "imageURL": "https://firebasestorage.googleapis.com/v0/b/fnapchat.appspot.com/o/images%2Fwelcome.jpg?alt=media&token=bffdd441-3e10-4f3b-82a4-26ceabd67eb6"]
        Database.database().reference().child("users").child(uid).child("snaps").childByAutoId().setValue(snap)
    }

}

