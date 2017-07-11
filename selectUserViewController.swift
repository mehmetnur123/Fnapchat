//
//  selectUserViewController.swift
//  Fnapchat
//
//  Created by Mehmet Nur on 09.07.17.
//  Copyright © 2017 Mehmet Nur. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class selectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var users : [User] = []
    var imageURL = ""
    var descrip = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            print(snapshot.key)
            
            let value = snapshot.value as? NSDictionary
            
            let user = User()
            user.mail = value!["mail"] as! String
            user.uid = snapshot.key
            self.users.append(user)
            self.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = users[indexPath.row].mail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let from = Auth.auth().currentUser?.email
        let snap = ["from":from, "description": descrip, "imageURL": imageURL]
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        navigationController?.popToRootViewController(animated: true)
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
