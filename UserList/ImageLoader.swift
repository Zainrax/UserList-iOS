//
//  ImageLoader.swift
//  UserList
//
//  Created by abra on 4/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    private var images = [URL: UIImage]()
    private var requests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
      if let image = images[url] {
        completionHandler(.success(image))
        return nil
      }
      let uuid = UUID()

      let task = URLSession.shared.dataTask(with: url) { data, res, err in

        defer {self.requests.removeValue(forKey: uuid) }
        if let data = data, let image = UIImage(data: data) {
              self.images[url] = image
              completionHandler(.success(image))
              return
        }
        guard let error = err else {
            print("API Fetch Error: \(err)")
            return
        }

        guard (error as NSError).code == NSURLErrorCancelled else {
            completionHandler(.failure(error))
            return
        }
      }
      task.resume()
      requests[uuid] = task
      return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      requests[uuid]?.cancel()
      requests.removeValue(forKey: uuid)
    }
}
