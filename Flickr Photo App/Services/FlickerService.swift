//
//  FlickerService.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import Foundation

class FlickrService {
    // Link constructor
    private func constructFlickrURL(tags: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/feeds/photos_public.gne"
        components.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: tags)
        ]
        return components.url
    }
    
    func fetchPhotos(for tags: String, completion: @escaping (Result<PhotosSearchModel, Error>) -> Void) {
        guard let url = constructFlickrURL(tags: tags) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -100, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -200, userInfo: nil)))
                return
            }
            do {
                let response = try JSONDecoder().decode(PhotosSearchModel.self, from: data)
                #if DEBUG
                print("JSON response is: ", response)
                #endif
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
