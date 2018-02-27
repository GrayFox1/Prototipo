//
//  DetailsViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 26/02/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var videoDisplay: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideo(videoCode : "bEDd3dxdJ-k")
    }
    
    func getVideo (videoCode : String){
        let url =  URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoDisplay.loadRequest(URLRequest(url : url!))
        
    }

}
