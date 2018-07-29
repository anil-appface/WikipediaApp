//
//  MTBaseTableViewController.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MTBaseTableViewController: UITableViewController {

    //Properties
    let noResultsDisplayLabel : UILabel = {
        
        let _noResultsDisplayLabel = UILabel()
        _noResultsDisplayLabel.textColor = UIColor.gray
        _noResultsDisplayLabel.textAlignment = .center
        _noResultsDisplayLabel.font = _noResultsDisplayLabel.font.withSize(14)
        _noResultsDisplayLabel.numberOfLines = 0
        return _noResultsDisplayLabel
        
    }()
    
    var searchController :UISearchController!
    
    //Mark: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:: Misc Functions
    
    //Create Search Controller for view controller.
    func createSearchController(viewController: UIViewController?)
    {
        
        self.searchController = ({
            // Setup One: This setup present the results in the current view.
            let controller = UISearchController(searchResultsController:viewController)
            controller.dimsBackgroundDuringPresentation = true
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.default
            controller.hidesNavigationBarDuringPresentation = true
            return controller
        })()
        

        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.barTintColor = UIColor.white
        navigationItem.hidesSearchBarWhenScrolling = true
        
        self.definesPresentationContext = true
        
    }
    


}



