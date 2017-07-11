//
//  SnapsViewController.swift
//  Fnapchat
//
//  Created by Mehmet Nur on 08.07.17.
//  Copyright © 2017 Mehmet Nur. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var snaps : [Snap] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
           
            let value = snapshot.value as? NSDictionary
            let snap = Snap()
            
            snap.imgUrl = value!["imageURL"] as! String
            snap.descrip = value!["description"] as! String
            snap.from = value!["from"] as! String
    
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = "FROM: \(snaps[indexPath.row].from)"
        cell.imageView?.sd_setImage(with: URL(string: snaps[indexPath.row].imgUrl), placeholderImage: UIImage(named: "universe.jpg"))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewSnapSegue"){
            let nextVC = segue.destination as! viewSnapViewController
            nextVC.snap = sender as! Snap
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
