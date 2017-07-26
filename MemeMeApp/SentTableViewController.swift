//
//  SentTableViewController.swift
//  MemeMeApp
//
//  Created by IceApinan on 6/25/2017 BE.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class SentTableViewController: UITableViewController,UINavigationControllerDelegate {
    var memes : [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if memes.count == 0 {
            presentMemeEditor()
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentTableCell")
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell?.imageView?.image = meme.memedImage
        return cell!
    }
    func presentMemeEditor () {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.present(controller, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.memes = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
