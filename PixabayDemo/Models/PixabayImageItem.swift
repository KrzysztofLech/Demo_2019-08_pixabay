//
//  PixabayImageItem.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import RealmSwift

final class PixabayImageItem: Object, Decodable {
    
    @objc dynamic var id: Int
    @objc dynamic var type: String
    
    @objc dynamic var imageWidth: Int
    @objc dynamic var imageHeight: Int
    @objc dynamic var imageSize: Int

    @objc dynamic var tags: String
    @objc dynamic var pageURL: String       // Source page on Pixabay,
                                            // which provides a download link for the original image
                                            // of the dimension imageWidth x imageHeight and the file size imageSize
    
    @objc dynamic var previewURL: String    // Low resolution images
                                            // with a maximum width or height of 150 px (previewWidth x previewHeight)
    @objc dynamic var previewWidth: Int
    @objc dynamic var previewHeight: Int

    @objc dynamic var webformatURL: String  // Medium sized image with a maximum width or height of 640 px (webformatWidth x webformatHeight)
                                            // URL valid for 24 hours
    @objc dynamic var webformatHeight: Int
    @objc dynamic var webformatWidth: Int
    
    @objc dynamic var largeImageURL: String // Scaled image with a maximum width/height of 1280px
    @objc dynamic var imageURL: String?     // URL to the original image (imageWidth x imageHeight) - for full API access
    
    @objc dynamic var user_id: Int          // User ID
    @objc dynamic var user: String          // User name
    @objc dynamic var userImageURL: String  // Profile picture URL (250 x 250 px)

    @objc dynamic var downloads: Int        // Total number of downloads
    @objc dynamic var views: Int            // Total number of views
    @objc dynamic var comments: Int         // Total number of comments
    @objc dynamic var likes: Int            // Total number of likes
    @objc dynamic var favorites: Int        // Total number of favorites
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
