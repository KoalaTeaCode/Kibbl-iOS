//
//  PetsSearchTableViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/15/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class PetsSearchTableViewController: UITableViewController {
    
    typealias model = PetModel
    typealias cellType = PetTableViewCell
    
    var lastData = [model]()
    var filteredData = [model]()
    
    // MARK: - Paging
    let pageSize = 10
    let preloadMargin = 5
    var lastLoadedPage = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String {
        get {
            return searchController.searchBar.text ?? ""
        }
    }
    
    lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.hidesWhenStopped = true
        return view
    }()
    
    var isLoading = false {
        didSet {
            switch isLoading {
            case true:
                activityView.startAnimating()
            case false:
                activityView.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        self.tableView.register(cellType.self, forCellReuseIdentifier: reuseIdentifier)
        
        searchController.searchBar.tintColor = Stylesheet.Colors.base
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
//        self.definesPresentationContext = true
        
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 99.calculateHeight()
        
        self.title = "Search"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(leftBarButtonPressed))
    }
    
    @objc func leftBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchController.searchBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchController.searchBar.isHidden = true
        self.searchController.searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! cellType
        
        let item = filteredData[indexPath.row]
        // Configure the cell...
        cell.selectionStyle = .none
        cell.setupCell(model: item)
        // @TODO: Remove this
        cell.heartImageButton.isHidden = true
        
        checkPage(indexPath: indexPath, item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredData[indexPath.row]
        let vc = PetDetailTableViewController()
        vc.pet = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PetsSearchTableViewController {
    // MARK: Data/Paging
    func checkPage(indexPath: IndexPath, item: model) {
        let nextPage: Int = Int(indexPath.item / pageSize) + 1
        let preloadIndex = nextPage * pageSize - preloadMargin
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) || indexPath == tableView?.indexPathForLastRow! {
            if let lastDate = item.lastUpdate {
                guard !self.isLoading else { return }
                self.isLoading = true
                getData(page: nextPage, lastItemDate: lastDate)
            }
        }
    }
    
    func getData(page: Int = 0, lastItemDate: String = "") {
        lastLoadedPage = page
        loadData(lastItemDate: lastItemDate)
    }
    
    func loadData(lastItemDate: String) {
        API.sharedInstance.getPetsWith(searchTerm: searchText.lowercased(), createdAtBefore: lastItemDate) { (returnedArray) in
            self.isLoading = false
            //@TODO: add podcastArray?.count is 0 check
            if let returnedArray = returnedArray {
                for item in returnedArray {
                    let existingObject = self.filteredData.filter { $0.key! == item.key! }.first
                    guard existingObject == nil else { continue }
                    self.filteredData.append(item)
                }
                // Guard for new data
                guard self.lastData != returnedArray else { return }
                self.lastData = returnedArray
                self.tableView.reloadData()
            }
        }
    }
}

extension PetsSearchTableViewController: UISearchControllerDelegate {
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        guard !searchBarIsEmpty() else { return }
        
        self.isLoading = true
        self.loadData(lastItemDate: "")
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension PetsSearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !filteredData.isEmpty {
            filteredData = [model]()
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension PetsSearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

