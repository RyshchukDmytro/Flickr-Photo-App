//
//  PhotoDetailView.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: PhotoModel
    @ObservedObject var viewModel: PhotoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: photo.media.m)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            Text(photo.title)
                .font(.headline)
            Text("Description: \(viewModel.extractDescription(from: photo.description))")
            Text("Author: \(viewModel.extractAuthor(from: photo.author))")
            Text("Published: \(viewModel.formattedDate(from: photo.published))")
        }
        
        HStack(alignment: .center) {
            Button(action: {
                viewModel.savePhoto(from: photo.media.m)
            }) {
                Text("Save Photo")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Photo Details")
        
        Spacer()
    }
}
