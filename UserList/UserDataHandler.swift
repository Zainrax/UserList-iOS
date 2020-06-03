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
    let dataContainer: CoreDataContainer = CoreDataContainer(model: "UserList")
    let apiDomain: String = "https://randomuser.me/api/"
    var users:[UserData] = []
    var totalResults: Int = 5000
    
    enum ResultKeys: CodingKey {
        case results
    }
    
    struct UserItems: Decodable {
        let results: [UserData]
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: ResultKeys.self)
            results = try values.decode([UserData].self, forKey: .results)
        }
    }
    
    public func fetchUsers() {
        self.fetchUsersData()
        self.fetchUsersAPI{ userData in
            self.users += userData
            self.dataContainer.saveContext()
        }
    }
    
    private func fetchUsersAPI(_ completionHandler: @escaping ([UserData])->Void) {
        let decoder = JSONDecoder()
        // Decoder needs CoreData context for UserData decoder
        let context = self.dataContainer.managedContext
        guard let userKeyContext = CodingUserInfoKey.context else {
            
            return
        }
        decoder.userInfo[userKeyContext] = context
        let urlString = apiDomain + "?results=\(totalResults)"
        guard let url = URL(string: urlString) else {
            print("Unable to get the url \(urlString)")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                print("API Fetch Error: \(err)")
                return
            }
            
            guard let httpResponse = res as? HTTPURLResponse, (httpResponse.statusCode >= 200) || (httpResponse.statusCode <= 299)else {
                print("Http Response Error: \(res)" )
                return
            }
            
            if  let data = data, let usersData = try? decoder.decode(UserItems.self, from: data) {
                completionHandler(usersData.results)
            }
            
        }
        task.resume()
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
