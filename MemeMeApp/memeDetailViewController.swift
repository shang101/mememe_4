//
//  memeDetailViewController.swift
//  MemeMeApp
//
//  Created by Shirley Hang on 5/27/15.
//  Copyright (c) 2015 att. All rights reserved.
//

import UIKit
//display Meme detail
class memeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    var memeDetail: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //display the meme details
        self.memeDetailImageView!.image = memeDetail.memedImage
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
    }
}
