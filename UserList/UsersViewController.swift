//
//  UsersViewController.swift
//  UserList
//
//  Created by abra on 4/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import UIKit
import MapKit

class UsersViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var userData: UserData?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = self.userData else {
            print("Unable to get userdata in View Controller")
            return
        }
        if let urlString = user.picture?.largeURL, let url = URL(string: urlString) {
            displayImage.loadImage(at: url)
        }
        name.text = user.name!.getFullName()
        gender.text = user.gender!
        dob.text = user.getDateString()
        location.text = user.location!.getFullAddress()
        map.delegate = self
        displayImage.layer.cornerRadius = displayImage.frame.width / 2
        displayImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

}
