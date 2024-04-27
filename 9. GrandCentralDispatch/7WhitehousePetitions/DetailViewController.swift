//
//  DetailViewController.swift
//  7WhitehousePetitions
//
//  Created by Satwika on 4/8/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var detailPetition: Petition?
    var webview: WKWebView?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let detailItem = detailPetition else {return}
        let htmlString = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        webview?.loadHTMLString(htmlString, baseURL: nil)
        
        
    }

}
