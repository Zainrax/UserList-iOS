//
//  UserDataHandler.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

class UserDataHandler: UserDataDelegate {
    var users:[UserData] = []
    
    func fetchUsers(completionHandler: ([UserData]) -> Void) {
        print("fetch")
    }
    
    func saveUsers() {
        print("save")
    }
    
    func deleteUsers(users:[UserData]) {
        print("delete")
    }
}
