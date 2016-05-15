//
//  OurTableViewController.swift
//  Hackathon
//
//  Created by 淡蓝色的泪 on 5/6/16.
//  Copyright © University of Southern California. All rights reserved.
//

import UIKit

class OurTableViewController: UITableViewController {
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    let countries = JSON(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("countries", ofType: "json")!)!)
    var filteredCountries = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.frame.size.height), animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCountries.count
        }
        return countries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)
        
        var data: JSON
        
        if searchController.active && searchController.searchBar.text != "" {
            data = filteredCountries[indexPath.row]
        } else {
            data = countries[indexPath.row]
        }
        
        let countryName = data["name"]["common"].stringValue
        let countryAddress = data["address"].stringValue
        
        cell.textLabel?.text = countryName
        cell.detailTextLabel?.text = countryAddress
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCountries = countries.array!.filter { country in
            return country["name"]["common"].stringValue.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
}

extension OurTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


