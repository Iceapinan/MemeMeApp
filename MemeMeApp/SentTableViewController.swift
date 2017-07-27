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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentMemeEditor))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = appDelegate.memes
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        memesCountIsZero {
            self.presentMemeEditor()
        }
        
    }
    
    func memesCountIsZero(_ function: @escaping () -> Void) {
        if memes.count == 0 {
            function()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentTableCell")
        let meme = memes[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell?.imageView?.image = meme.memedImage
        return cell!
    }
     func presentMemeEditor () {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! MemeEditorViewController
        self.present(controller, animated: true, completion: { () -> Void in
            self.memesCountIsZero {
                controller.cancelButton.isEnabled = false
                controller.shareButton.isEnabled = false
            }
        })
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = memes[(indexPath as NSIndexPath).row]
        detailController.memes = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            memes.remove(at: indexPath.row)
            appDelegate.memes = memes
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            memesCountIsZero {
                self.presentMemeEditor()
            }
        }
        
        
    }
    
}
