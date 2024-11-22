//
//  PhotoGridView.swift
//  Flickr Photo App
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import SwiftUI

struct PhotoGridView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText, onEditingChanged: { _ in
                    viewModel.searchPhotos(tags: searchText)
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink(destination: PhotoDetailView(photo: photo, viewModel: viewModel)) {
                                    AsyncImage(url: URL(string: photo.media.m)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}

#Preview {
    PhotoGridView()
}
