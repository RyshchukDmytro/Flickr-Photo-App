//
//  PhotoViewModel.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import Foundation
import Combine

class PhotoViewModel: ObservableObject {
    @Published var photos: [PhotoModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = FlickrService()
    
    // search photos by request keywords
    func searchPhotos(tags: String) {
        guard !tags.isEmpty else {
            photos = []
            return
        }
        isLoading = true
        service.fetchPhotos(for: tags) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let photos):
                    self?.photos = photos.items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func formattedDate(from isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoDate) else { return isoDate }
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        return outputFormatter.string(from: date)
    }
}
