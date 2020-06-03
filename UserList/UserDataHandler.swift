//
//  UserDataHandler.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

class UserDataHandler: UserDataDelegate {
    
    var users:[UserData] = []
    
    public func fetchUsers(completionHandler: ([UserData]) -> Void?) {
        let apiUserData = self.fetchUsersAPI()
        let dbUserData = self.fetchUsersData()
    }
    
    private func fetchUsersAPI() -> UserData {
        return []
    }
    
    private func fetchUsersData() -> UserData {
        return []
    }
    
    public func saveUsers() {
        print("save")
    }
    
    public func deleteUsers(users:[UserData]) {
        print("delete")
    }
}
