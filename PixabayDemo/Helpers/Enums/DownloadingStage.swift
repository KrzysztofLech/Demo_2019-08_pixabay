//
//  DownloadingStage.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 05/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

enum DownloadingStage {
    case none
    case downloadingData
    case downloadingImages
    case done
    
    var message: String {
        switch self {
        case .none:              return ""
        case .downloadingData:   return "Downloading collections data"
        case .downloadingImages: return "Downloading images"
        case .done:              return "All data downloaded"
        }
    }
    
    var almostDoneMessage: String {
        let extraMessage = "Almost done 🙂"
        return self.message + "\n" + extraMessage
    }
}
