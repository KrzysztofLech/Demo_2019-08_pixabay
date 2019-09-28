//
//  DataManager.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 29/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import RealmSwift

class DataManager: NSObject {
    
    static let shared = DataManager()
    //private var realm = try! Realm()
    
    
//    func realmWrite(operations: @escaping () -> Void) {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            autoreleasepool {
//                try? self?.realm.write {
//                    operations()
//                }
//
//            }
//        }
//    }
//
//    func addObject<T: Object>(object: T) {
//        realmWrite {
//            self.realm.add(object)
//        }
//    }
//
//
//    func addObjects<T: Object>(objects: [T]) {
//        realmWrite {
//            self.realm.add(objects)
//            print("Zapisano: ", objects.count)
//        }
//    }

    func deleteAll() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
            }
        }
    }
    
    func addObject<T: Object>(object: T) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    realm.add(object)
                }
            }
        }
    }
    
//    func addObjects<T: Object>(objects: [T]) {
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.add(objects)
//                }
//            }
//        }
//    }

    

//    func updateDataBase(withObjects objects: [PixabayImageItem]) {
//        objects.forEach {
//            self.savePixabayImageItemIfNotExist(object: $0)
//        }
//    }
    
//    private func savePixabayImageItemIfNotExist(object: PixabayImageItem) {
//        let realm = try! Realm()
//        if let object = realm.object(ofType: PixabayImageItem.self, forPrimaryKey: object.id) {
//        if object == nil {
//            addObject(object: object)
//        }
//    }
    
    func fetchAllImageItems() -> Results<PixabayImageItem> {
        let realm = try! Realm()
        return realm.objects(PixabayImageItem.self)
    }
    
//    func fetchAllImageItems() -> [PixabayImageItem] {
//        let realm = try! Realm()
//        let results = realm.objects(PixabayImageItem.self)
//
//        var array: [PixabayImageItem] = []
//        results.forEach {
//            array.append($0)
//        }
//        print("$$$$$$: ", array.count)
//        return array
//    }


//    func fetchAllImageItems() -> [PixabayImageItem] {
//        let realm = try! Realm()
//        let images = realm.objects(PixabayImageItem.self)
//
//        var array = [PixabayImageItem]()
//
//        let imagesRef = ThreadSafeReference(to: images)
//        DispatchQueue.global().async {
//            let realm = try! Realm()
//            if let images = realm.resolve(imagesRef) {
//                print("OK")
//
//                images.forEach {
//                    array.append($0)
//                }
//
//                return array
//
//            } else {
//                print("Not OK!")
//            }
//        }
//
//        print("$$$$$$: ", array.count)
//
//        return array
//    }

//    func processInBackground(_ movie: Movie) {
//        let movieRef = ThreadSafeReference(to: movie)
//        DispatchQueue.global().async {
//            let realm = try! Realm()
//            if let movie = realm.resolve(movieRef) {
//                print("Processing movie with title: \(movie.title) in the background")
//            } else {
//                print("Movie cannot be resolved")
//            }
//        }
//    }

    
    func fetchCollections() -> Results<PictureCollection> {
        let realm = try! Realm()
        return realm.objects(PictureCollection.self)
    }

    
    /// przenieść do view modelu
//    func findPreviewImage(withId id: Int) -> UIImage? {
//
//        guard
//            let object = realm.object(ofType: PixaBayImage.self, forPrimaryKey: id),
//            let imageData = object.previewSizeImageData
//            else { return nil }
//        return UIImage(data: imageData)
//    }
}
