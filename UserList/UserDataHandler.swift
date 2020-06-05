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
    let seed: String = "aaabbbccc"
    let totalResults: Int = 5000
    var users:[UserData] = []
    var page: Int = 1
    var fetchAmount: Int = 20
    
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
    
    init() {
        self.users = self.fetchUsersData()
        self.page = (self.users.count / fetchAmount) + 1
    }
    
    public func fetchUsers(_ completionHandler: (()->Void)?) {
        self.fetchUsersAPI{ userData in
            self.users += userData.filter{!self.users.contains($0)}
            if let user = self.users.first, let context = user.managedObjectContext {
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Fetch API core data error: \(error)")
                }
            }
//            DispatchQueue.global(qos: .utility).async {
//                self.dataContainer.saveContext()
//            }
            (completionHandler ?? {})()
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
        let urlString = self.apiDomain + "?page=\(self.page)"+"&results=\(self.fetchAmount)" + "&seed=\(self.seed)"
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
            DispatchQueue.main.async {
                if  let data = data, let usersData = try? decoder.decode(UserItems.self, from: data) {
                    completionHandler(usersData.results)
                }
            }
        }
        task.resume()
        
    }
    
    internal func fetchUsersData() -> [UserData]{
        let userFetch: NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let results = try self.dataContainer.managedContext.fetch(userFetch)
            return results
        } catch let error as NSError{
            print("CoreData Fetch Error: \(error), \(error.userInfo)")
        }
        return []
    }
    
    public func deleteUsers(users:[UserData]) {
        self.users = self.users.filter{ user in
            !users.contains(user)
        }
        users.forEach{
            self.dataContainer.managedContext.delete($0)
        }
        self.dataContainer.saveContext()
    }
}
