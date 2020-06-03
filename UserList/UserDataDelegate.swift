//
//  UserDataDelegate.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

protocol UserDataDelegate {
    var users: [UserData] {get}
    
    func fetchUsers()
    func saveUsers()
    func deleteUsers(users:[UserData])
}
