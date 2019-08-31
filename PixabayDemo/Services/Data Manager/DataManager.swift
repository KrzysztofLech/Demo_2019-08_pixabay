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
    private let realm = try! Realm()
    
    
    func addObject<T: Object>(object: T) {
        try! realm.write {
            realm.add(object)
        }
    }

    func addObjects<T: Object>(objects: [T]) {
        try! realm.write {
            realm.add(objects)
            print("Zapisano: ", objects.count)
        }
    }

    func updateDataBase(withObjects objects: [PixabayImageItem]) {
        objects.forEach {
            self.savePixabayImageItemIfNotExist(object: $0)
        }
    }
    
    private func savePixabayImageItemIfNotExist(object: PixabayImageItem) {
        let existObject = realm.object(ofType: PixabayImageItem.self, forPrimaryKey: object.id)
        if existObject == nil { addObject(object: object) }
    }
    
    
    /// przenieść do view modelu
    func findPreviewImage(withId id: Int) -> UIImage? {
        guard
            let object = realm.object(ofType: PixaBayImage.self, forPrimaryKey: id),
            let imageData = object.previewSizeImageData
            else { return nil }
        return UIImage(data: imageData)
    }
    
    
    /*
    func retrieveAllDataForObject(_ T : Object.Type) -> [Object] {
        var objects = [Object]()
        for result in realmObject.objects(T) {
            objects.append(result)
        }
        return objects
    }
    
    func deleteAllDataForObject(_ T : Object.Type) {
        //self.delete(self.getAllDataForObject(T))
    }
    
    func replaceAllDataForObject(_ T : Object.Type, with objects : [Object]) {
        deleteAllDataForObject(T)
        add(objects)
    }
    
    func add(_ objects : [Object], completion : @escaping() -> ()) {
        try! realmObject.write{
            
            realmObject.add(objects)
            completion()
        }
    }
    
    func add(_ objects : [Object]) {
        try! realmObject.write{
            
            realmObject.add(objects)
        }
    }
    
    func update(_ block: @escaping ()->Void) {
        try! realmObject.write(block)
    }
    
    func delete(_ objects : [Object]) {
        try! realmObject.write{
            realmObject.delete(objects)
        }
    }
 */
}
