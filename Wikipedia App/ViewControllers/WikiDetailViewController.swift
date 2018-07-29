//
//  WikiDetailViewController.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 28/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import WebKit

class WikiDetailViewController: UIViewController {

    @IBOutlet var wkWebView: WKWebView!
    var pageId: Int64?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wkWebView.navigationDelegate = self
        fetchDetails()


    }

    
    private func fetchDetails(){
        if let _ = pageId {
            MTSyncEngine.sharedInstance.getWikiSearchDetailUrl(forPageId: String(pageId!), completionHandler: { [weak self](urlString) in
                
                guard let urlStr = urlString else {
                    self?.showAlert(title: "Money Tap", message: "Failed to fetch details at this time. Please try again after some time")
                    return
                }
                
                guard let url = URL.init(string: urlStr) else {
                    self?.showAlert(title: "Money Tap", message: "Failed to fetch details at this time. Please try again after some time")
                    return
                }
                
                
                
                let urlRequest = URLRequest(url: url)
                
                self?.wkWebView.load(urlRequest)
                
                
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WikiDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
}
