//
//  PlayerViewController.swift
//  AVPlayer
//
//  Created by Francis Tseng on 2017/9/6.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayerViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }
    
    func configureSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 50)

        searchController.searchBar.placeholder = "Enter URL of video"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.view.addSubview(searchController.searchBar)
        
        
    }
   
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
