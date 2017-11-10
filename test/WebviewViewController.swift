//
//  WebviewViewController.swift
//  test
//
//  Created by yuting jiang on 2017/11/7.
//  Copyright © 2017年 yuting jiang. All rights reserved.
//

import UIKit
import Foundation

class WebviewViewController: UIViewController {

    var url: String?
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        webview.loadRequest(URLRequest(url: URL(string: url!)!))
    }


}

//extension ViewController {
//    self.articles
//}

