//
//  UserDetailsTableViewController.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    let userDataHandler: UserDataHandler = UserDataHandler()
    let imageLoader: ImageLoader = ImageLoader()
    let df = DateFormatter()
    let paginationLimit: Int = 20
    let leadingOnBatch: CGFloat = 3.0
    var filteredUsers: [UserData] = []
    var canFetch: Bool {
        if self.userDataHandler.users.count <= self.userDataHandler.totalResults {
            return true
        }
        return false
    }
    
    var isSearchEmpty: Bool {
        let searchBar = self.searchController.searchBar
        return searchBar.text?.isEmpty ?? true
    }
    
    var inSearch: Bool {
        let searchBar = self.searchController.searchBar
        let searching = searchBar.selectedScopeButtonIndex != 0
      return !isSearchEmpty || searching
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.userDataHandler.fetchAmount = paginationLimit
        // Do any additional setup after loading the view.
        self.userDataHandler.fetchUsers({
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        })
        df.dateFormat = "dd-MM-yyyy"
        self.filteredUsers = self.userDataHandler.users
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchBar.scopeButtonTitles = ["All", "Male", "Female"]
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        self.tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if inSearch {
            return self.filteredUsers.count
        } else {
            return self.userDataHandler.users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user: UserData
        if inSearch {
            user = self.filteredUsers[indexPath.row]
        } else {
            user = self.userDataHandler.users[indexPath.row]
        }
        if let name = user.name {
            cell.name.text = name.getFullName()
        }
        if let image = user.picture, let url = URL(string: image.thumbnailURL!) {
            cell.userImageView.loadImage(at: url)
        }
        if let dob = user.dateOfBirth {
            cell.dob.text = df.string(from: dob)
        }
        if let gender = user.gender {
            cell.gender.text = gender
        }
        
      return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * self.leadingOnBatch {
            if canFetch {
                self.userDataHandler.page += 1
                self.userDataHandler.fetchUsers({
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func filterUsersForSearch(searchText: String, scope: String) {
        filteredUsers = self.userDataHandler.users.filter { user in
            let inScope = scope == "All" || user.gender!.lowercased() == scope.lowercased()
            if isSearchEmpty {
                return inScope
            } else {
                return user.name!.getFullName().lowercased().contains(searchText.lowercased()) && inScope
            }
        }
    }
}

extension UserDetailsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension UserDetailsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterUsersForSearch(searchText: searchBar.text!, scope: scope)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar,  textDidChange: String) {
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterUsersForSearch(searchText: searchBar.text!, scope: scope)
        tableView.reloadData()
    }
}
