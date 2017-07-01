//
//  SentTableViewController.swift
//  MemeMeApp
//
//  Created by IceApinan on 1/7/2560 BE.
//  Copyright © 2560 IceApinan. All rights reserved.
//

import UIKit

class SentTableViewController: UITableViewController {
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentTableCell")!
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(controller, animated: false, completion: nil)
        return cell
    }

}
