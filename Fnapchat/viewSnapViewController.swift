//
//  viewSnapViewController.swift
//  Fnapchat
//
//  Created by Mehmet Nur on 10.07.17.
//  Copyright © 2017 Mehmet Nur. All rights reserved.
//

import UIKit
import SDWebImage

class viewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var snap = Snap()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imgUrl), placeholderImage: UIImage(named: "universe.jpg"))
        
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
