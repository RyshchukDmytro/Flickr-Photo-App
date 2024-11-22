//
//  PhotoModel.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import Foundation

// General model from JSON
struct PhotosSearchModel: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [PhotoModel]
}

// Model for each photo
struct PhotoModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorID: String
    var tags: String
    
    struct Media: Codable {
        let m: String
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, media, description, published, author, tags
        case dateTaken = "date_taken"
        case authorID = "author_id"
    }
}
