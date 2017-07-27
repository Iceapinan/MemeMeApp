//
//  DetailViewController.swift
//  MemeMeApp
//
//  Created by IceApinan on 6/25/2017 BE.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var memes : Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageView!.image = memes.memedImage
        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    

}
