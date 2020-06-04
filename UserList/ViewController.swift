//
//  ViewController.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let userDataHandler: UserDataHandler = UserDataHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.userDataHandler.fetchUsers({})
    }


}

