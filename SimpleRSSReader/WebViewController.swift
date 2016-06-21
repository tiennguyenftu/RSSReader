//
//  WebViewController.swift
//  SimpleRSSReader
//
//  Created by Tien 95 on 6/21/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlString: String!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.frame)
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        webView.loadRequest(request)
        view.addSubview(webView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        webView.addSubview(activityIndicator)
        
        webView.navigationDelegate = self
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

}
