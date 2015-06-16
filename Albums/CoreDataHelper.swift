
//
//  CoreDataHelper.swift
//  Albums
//
//  Created by DmitrJuga on 13.06.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    private static let modelFileName = "Model"
    private static let modelFileExt = "momd"
    private static let storeFileName = "database.sqlite"

    let model: NSManagedObjectModel
    let coordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext
    
    
    // синглтон
    static let sharedInstance = CoreDataHelper()
    

    // инициализация стека CoreData
    private init() {
        var error: NSError? = nil
        
        // ManagedObjectModel
        if let modelURL = NSBundle.mainBundle().URLForResource(CoreDataHelper.modelFileName,
                                                withExtension: CoreDataHelper.modelFileExt) {
            if let model = NSManagedObjectModel(contentsOfURL: modelURL) {
                self.model = model
            } else {
                fatalError("ManagedObjectModel creating error")
            }
        } else {
            fatalError("File \(CoreDataHelper.modelFileName).\(CoreDataHelper.modelFileExt) not found in the main bundle.")
        }
        
        // PersistentStoreCoordinator
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as! NSURL
        let storeURL = docsURL.URLByAppendingPathComponent(CoreDataHelper.storeFileName)
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        if self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil,
                                                       URL: storeURL, options: nil, error: &error) == nil {
            fatalError("Unresolved error \(error), \(error!.userInfo)");
        }
        // ManagedObjectContext
        self.context = NSManagedObjectContext();
        self.context.persistentStoreCoordinator = self.coordinator;
    }
  
    
    // сохранение контекста
    func save() {
        var error: NSError? = nil
        if self.context.hasChanges && !self.context.save(&error) {
            fatalError("\(error), \(error!.userInfo)")
        }
    }
    
    
    // создание нового объекта для указанного entity
    func addObjectForEntityNamed(entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext:self.context) as! NSManagedObject
    }
    
    
    // получение всех объектов для указанного entity c сортировкой
    func fetchObjectsForEntityNamed(entityName: String, sortedBy sortKeys: [String] = []) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName)
        // задаем сортировку
        if sortKeys.count > 0 {
            request.sortDescriptors = sortKeys.map{NSSortDescriptor(key: $0, ascending: true)};
        }
        // выполняем запрос
        var error: NSError? = nil
        let array = self.context.executeFetchRequest(request, error: &error) as! [NSManagedObject];
        if let error = error {
            fatalError("FETCH ERROR \(error), \(error.userInfo)")
        }
        return array
    }

    
    // удаление объекта
    func deleteObject(object: NSManagedObject) {
        self.context.deleteObject(object)
    }

}
