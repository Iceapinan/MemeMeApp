//
//  SentCollectionViewController.swift
//  MemeMeApp
//
//  Created by IceApinan on 6/25/2017 BE.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class SentCollectionViewController: UICollectionViewController {
    var memes : [Meme]!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentMemeEditor))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    @objc func presentMemeEditor () {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! MemeEditorViewController
        self.present(controller, animated: true, completion: { () -> Void in
            if self.memes.count == 0 {
                controller.cancelButton.isEnabled = false
                controller.shareButton.isEnabled = false
            }
        })
    }
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentCollectionCell", for: indexPath) as! SentCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.SCImageView.image = meme.memedImage
        print(meme.memedImage)
        print(meme.memedImage.size)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.memes = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    

}
