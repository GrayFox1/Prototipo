//
//  DepoimentosViewController.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 07/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class DepoimentosViewController: UIViewController {

    @IBOutlet weak var videoDisplay: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideo(videoCode : "wGlhsv30Exc")
    }
    
    func getVideo (videoCode : String){
        let url =  URL(string: "https://www.youtube.com/embed/\(videoCode)")
        videoDisplay.loadRequest(URLRequest(url : url!))
        
    }


}
