//
//  PhotoViewModel.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import Foundation
import Combine
import SwiftSoup

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
    
    // to make description user friendly
    func extractDescription(from htmlString: String) -> String {
        let noDescriptionText = "No description available."
        do {
            // Use SwiftSoup framework to parse readable text from description
            let document = try SwiftSoup.parse(htmlString)
            let paragraphs = try document.select("p")
            let text = try paragraphs.last()?.text() ?? ""
            return !text.isEmpty ? text : noDescriptionText
        } catch {
            print("Error parsing HTML: \(error.localizedDescription)")
            return noDescriptionText
        }
    }
    
    // to make author user friendly
    func extractAuthor(from text: String) -> String {
        if text.contains("nobody@flickr.com") {
            if let start = text.range(of: "(\"")?.upperBound,
               let end = text.range(of: "\")", range: start..<text.endIndex)?.lowerBound {
                return String(text[start..<end])
            }
        }
        return text
    }
}
