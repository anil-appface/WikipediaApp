//
//  WikiSearchTableViewController.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import CoreData

class WikiSearchTableViewController: MTBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        setUpSearchController()
        noResultsDisplayLabel.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
        tableView.tableFooterView = nil
     
        if let count = fetchedResultsController.fetchedObjects?.count, count == 0 {
            noResultsDisplayLabel.text = "No Search results. \n Please search with proper search keyword."
            tableView.backgroundView = noResultsDisplayLabel
        }
    }
    
    
    private func setUpSearchController() {
        createSearchController(viewController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.text = MTDataManager.sharedInstance.getSearchKeywordFromUserDefaults()
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.placeholder = "Search Wiki"
        searchController.searchBar.scopeButtonTitles = ["English", "Dutch"]
        switch MTDataManager.sharedInstance.getBaseUrlFromUserDefaults().lowercased()
        {
            case kBaseUrl_English:
                searchController.searchBar.selectedScopeButtonIndex = 0
            case kBaseUrl_Dutch:
                searchController.searchBar.selectedScopeButtonIndex = 1
            default:
                break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiSearchTableCellIdentifier", for: indexPath) as! WikiSearchTableCell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: WikiSearchTableCell, at indexPath: IndexPath) {
        
        // Get the object at the current index from the fetched results controller
        let mtSearchResult = self.fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.configureSearchTableCell(mtSearchRecord: mtSearchResult)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mtSearchResult = self.fetchedResultsController.object(at: indexPath)
        
        self.performSegue(withIdentifier: "detailSegue", sender: mtSearchResult.pageId)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailSegue" {
            if let destinationVC = segue.destination as? WikiDetailViewController {
                destinationVC.pageId = sender as? Int64
            }
        }
    }
    
    
    var _fetchedResultsController: NSFetchedResultsController<MTWikiSearchResultEntity>? = nil
    
    // The proxy variable to serve as a lazy getter to our
    // fetched results controller.
    var fetchedResultsController: NSFetchedResultsController<MTWikiSearchResultEntity>
    {
        // If the variable is already initialized we return that instance.
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If not, lets build the required elements for the fetched
        // results controller.
        
        // First we need to create a fetch request with the pretended type.
        let fetchRequest: NSFetchRequest<MTWikiSearchResultEntity> = MTWikiSearchResultEntity.fetchRequest()
        
        // Optional: we can set the batch size to a suitable number.
        
        // Since we have to create at least one sort order attribute and type (ascending\descending)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        
        // Set the sort objects to the fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let managedObjectContext = appDelegate.coreDataManager.managedObjectContext
        
        // Create the fetched results controller instance with the defined attributes.
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set the delegate of the fetched results controller to the view controller.
        // with this we will get notified whenever occurs changes on the data.
        aFetchedResultsController.delegate = self
        
        // Setting the created instance to the view controller instance.
        _fetchedResultsController = aFetchedResultsController
        
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller
            // will only retrieve more records if necessary.
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
}


extension WikiSearchTableViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? WikiSearchTableCell {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    //to update the table data whenever there is a change in the MOC.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        tableView.endUpdates()
        
        guard let count = controller.fetchedObjects?.count, count > 0 else {
            self.noResultsDisplayLabel.text = "No Search results.\n Please search with proper search keyword."
            self.tableView.backgroundView = noResultsDisplayLabel
            return
        }
            
        self.tableView.backgroundView = nil
    }
}


//MARK: UISearch Delegates
extension WikiSearchTableViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    //We need to show the searched text in search bar always.
    func willDismissSearchController(_ searchController: UISearchController) {
        
        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.text = MTDataManager.sharedInstance.getSearchKeywordFromUserDefaults()
        }
        
    }
    
    internal func updateSearchResults(for searchController: UISearchController)
    {
        getSearchResultsForSearchbar(searchBar: searchController.searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        let languageSelected = searchBar.scopeButtonTitles![selectedScope]
        
        switch languageSelected.lowercased() {
            case "english":
                MTDataManager.sharedInstance.setBaseUrlFromUserDefaults(url: kBaseUrl_English)
            case "dutch":
                MTDataManager.sharedInstance.setBaseUrlFromUserDefaults(url: kBaseUrl_Dutch)
            default:
                break
        }
        
        appDelegate.configureBaseUrl()
        getSearchResultsForSearchbar(searchBar: searchBar)
    }
    

    private func getSearchResultsForSearchbar(searchBar: UISearchBar) {
        
        guard let searchString = searchController.searchBar.text else {
            
            MTDataManager.sharedInstance.setSearchKeywordFromUserDefaults(keyword: "")
            return
        }
        
        if searchString.count > 3 {
            
            MTDataManager.sharedInstance.setSearchKeywordFromUserDefaults(keyword: searchString)
            MTSyncEngine.sharedInstance.getWikiSearchResults(forSearchString: searchString)
            
        }
    }
    
}


// Table Cell
class WikiSearchTableCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if !selected {
            UIView.animate(withDuration: 1) { [weak self] in
                self?.containerView.backgroundColor =  UIColor.white
            }
        } else {
            containerView.backgroundColor = UIColor.lightGray
        }
        
        
    }
    
    func configureSearchTableCell(mtSearchRecord: MTWikiSearchResultEntity) {
        
        
        if let thumbnailUrlString = mtSearchRecord.thumbnail {
            //thumbnailImageView.isHidden = false
            print(thumbnailUrlString)
            thumbnailImageView.loadImageUsingCache(withUrl: thumbnailUrlString)
        } else {
            thumbnailImageView.image = #imageLiteral(resourceName: "WikiPlaceholderIcon")
        }
        
        titleLabel.text = mtSearchRecord.title
        descriptionLabel.text = mtSearchRecord.desc
        
    }
    
}





