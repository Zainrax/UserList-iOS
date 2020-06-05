//
//  UserDetailsTableViewController.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import UIKit

class UserDetailsTableViewController: UITableViewController {
    let userDataHandler: UserDataHandler = UserDataHandler()
    let imageLoader: ImageLoader = ImageLoader()
    let df = DateFormatter()
    let paginationLimit: Int = 20
    let leadingOnBatch: CGFloat = 3.0
    var users: [UserData] = []
    var canFetch: Bool {
        if self.userDataHandler.users.count <= self.userDataHandler.totalResults {
            return true
        }
        return false
    }
    
    var isSearchEmpty: Bool {
        guard let searchBar = self.tableView.tableHeaderView as? UISearchBar else {
            print("Could not find search bar")
            return false
        }
      return searchBar.text?.isEmpty ?? true
    }
    
    var inSearch: Bool {
        guard let searchBar = self.tableView.tableHeaderView as? UISearchBar else {
            print("Could not find search bar")
            return false
        }
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
        self.users = self.userDataHandler.users
        df.dateFormat = "dd-MM-yyyy"
    
        let searchController = UISearchController(searchResultsController: self)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = false
        
        self.tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.userDataHandler.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user: UserData
        if inSearch {
            user = self.users[indexPath.row]
        } else {
            user = self.userDataHandler.users[indexPath.row]
        }
        if let name = user.name {
            var title = name.title!
            title = title == "Madamoiselle" ? "Mlle" : title
            let fullName = "\(title). \(name.first!) \(name.last!)"
            cell.name.text = fullName
        }
        if let image = user.picture, let url = URL(string: image.thumbnailURL!) {
            let requestToken = imageLoader.loadImage(url) { result in
                do {
                    let image = try result.get()
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                } catch let error as NSError {
                    print("Load Image error: \(error)")
                }
            }
            cell.onReuse = {
                if let requestToken = requestToken {
                    self.imageLoader.cancelLoad(requestToken)
                }
            }
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
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension UserDetailsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
