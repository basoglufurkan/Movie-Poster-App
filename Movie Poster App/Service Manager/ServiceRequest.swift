//
//  ServiceRequest.swift
//  Movie Poster App
//
//  Created by Furkan BAŞOĞLU on 31.10.2023.
//

import Foundation

class Services {
    let session: URLSession
    private var images = NSCache<NSString, NSData>()
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    static let shared = Services()
    
    func getData(searchStr: String, completion: (([OmdbModel])-> Void)?) {
        var request = URLRequest(url: URL(string: "https://www.omdbapi.com/?t=\(searchStr)&y=&plot=short&r=json&apikey=4c7bd3d9")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            do {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let model = OmdbModel(json)
                    completion?([model])
                } else if let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    let arr = json.map({OmdbModel($0)})
                    completion?(arr)
                } else {
                    completion?([])
                }
            }
        }
        task.resume()
    }
    
    private func download(imageURL: URL, completion: @escaping (Data?) -> (Void)) {
      if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
        print("using cached images")
        completion(imageData as Data)
        return
      }
      
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
          if error != nil {
          completion(nil)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil)
          return
        }
        
        guard let localUrl = localUrl else {
          completion(nil)
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
          completion(data)
        } catch {
          completion(nil)
        }
      }
      
      task.resume()
    }
    
    func image(poster: String, completion: @escaping (Data?) -> (Void)) {
        guard let url = URL(string: poster) else {return}
        download(imageURL: url, completion: completion)
    }
    
}
