//
//  UIImageLoader.swift
//  UserList
//
//  Created by abra on 5/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import Foundation
import UIKit

class UIImageLoader {
  static let loader = UIImageLoader()

  private let imageLoader = ImageLoader()
  private var uuidMap = [UIImageView: UUID]()

  private init() {}

  func load(_ url: URL, for imageView: UIImageView) {
    let token = imageLoader.loadImage(url) { result in
       defer { self.uuidMap.removeValue(forKey: imageView) }
       do {
         let image = try result.get()
         DispatchQueue.main.async {
           imageView.image = image
         }
       } catch let error as NSError {
         print("Load Image Error: \(error)")
       }
     }
     if let token = token {
       uuidMap[imageView] = token
     }
  }

  func cancel(for imageView: UIImageView) {
    if let uuid = uuidMap[imageView] {
      imageLoader.cancelLoad(uuid)
      uuidMap.removeValue(forKey: imageView)
    }
  }
}

extension UIImageView {
  func loadImage(at url: URL) {
    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
