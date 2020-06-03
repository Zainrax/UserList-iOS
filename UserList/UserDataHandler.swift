//
//  UserDataHandler.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//
import CoreData
import UIKit

class UserDataHandler: UserDataDelegate {
    var dataContainer: CoreDataContainer = CoreDataContainer(model: "UserList")
    var users:[UserData] = []
    var apiDomain: String = ""
    
    public func fetchUsers() {
        self.fetchUsersData()
        self.fetchUsersAPI()
    }
    
    private func fetchUsersAPI() {
        print("fetch")
    }
    
    private func fetchUsersData(){
        let userFetch: NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let results = try self.dataContainer.managedContext.fetch(userFetch)
            self.users += results.filter{!self.users.contains($0)}
        } catch let error as NSError{
            print("CoreData Fetch Error: \(error), \(error.userInfo)")
        }
    }
    
    public func saveUsers() {
        print("save")
    }
    
    public func deleteUsers(users:[UserData]) {
        print("delete")
    }
}
