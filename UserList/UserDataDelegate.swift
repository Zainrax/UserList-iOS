//
//  UserDataDelegate.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

protocol UserDataDelegate {
    var users: [UserData] {get}
    
    public func fetchUsers(@escaping completionHandler: ([UserData])-> Void?)
    public func saveUsers()
    public func deleteUsers(users:[UserData])
    private func fetchUsersAPI() -> UserData
    private func fetchUsersData() -> UserData
}
