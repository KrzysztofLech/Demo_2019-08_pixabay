//
//  PixabayImageItem.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

final class PixabayImageItem: Decodable {
    
    let id: Int
    let type: String
    
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int

    let tags: String
    let pageURL: String       // Source page on Pixabay,
                              // which provides a download link for the original image
                              // of the dimension imageWidth x imageHeight and the file size imageSize
    
    let previewURL: String    // Low resolution images
                              // with a maximum width or height of 150 px (previewWidth x previewHeight)
    let previewWidth: Int
    let previewHeight: Int

    let webformatURL: String  // Medium sized image with a maximum width or height of 640 px (webformatWidth x webformatHeight)
                              // URL valid for 24 hours
    let webformatHeight: Int
    let webformatWidth: Int
    
    let largeImageURL: String // Scaled image with a maximum width/height of 1280px
    let imageURL: String?     // URL to the original image (imageWidth x imageHeight) - for full API access
    
    let user_id: Int          // User ID
    let user: String          // User name
    let userImageURL: String  // Profile picture URL (250 x 250 px)

    let downloads: Int        // Total number of downloads
    let views: Int            // Total number of views
    let comments: Int         // Total number of comments
    let likes: Int            // Total number of likes
    let favorites: Int        // Total number of favorites    
}
