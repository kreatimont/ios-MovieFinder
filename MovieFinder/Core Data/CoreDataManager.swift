//
//  CoreDataManager.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 12/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

class CoreDataManager: NSObject {
    
    typealias TransactionCompletion = (Bool) -> ()
    
    static let shared = CoreDataManager()
    private override init() {}
    
    var dbFilePath: String? {
        return persistentContainer.persistentStoreCoordinator.persistentStores.first?.url?.absoluteString
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MovieFinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

//MARK: - helpers methods

extension CoreDataManager {
    
    func perform<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>, on context: NSManagedObjectContext) -> [T]? {
        var log = "[CoreData] Prepared request for entity: '\(fetchRequest.entityName ?? "")'"
        if let predicate = fetchRequest.predicate {
            log.append(" with predicate: \(predicate.description);")
        }
        if let sortDescriptors = fetchRequest.sortDescriptors {
            log.append(" with sortDescriptors: \(sortDescriptors.description);")
        }
        log.append("📂")
        do {
            let result = try context.fetch(fetchRequest)
            log.append(" successed, count: \(result.count) ✅\n")
            DDLogInfo(log)
            return result
        } catch {
            log.append(" failed ❌ error: \(error.localizedDescription)\n")
            DDLogInfo(log)
            return nil
        }
    }
    
}


extension CoreDataManager {
    
    func saveWatchlistMovies(movies: [WatchlistMovie], completion: TransactionCompletion?) {
        self.persistentContainer.performBackgroundTask { (privateMoc) in
            
            let requestToDelete = NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
            if let result = self.perform(fetchRequest: requestToDelete, on: privateMoc) {
                for item in result {
                    privateMoc.delete(item)
                }
            }
            try? privateMoc.save()
            
            for movie in movies {
                let wMovie = WatchlistMovie(context: privateMoc)
                wMovie.id = movie.id
                wMovie.name = movie.name
            }

            do {
                try privateMoc.save()
                DDLogInfo("[CoreData] saved templates count: \(movies.count) 📂✅\n")
                completion?(true)
            } catch {
                DDLogInfo("[CoreData] failed to save templates 📂❌\n")
                completion?(false)
            }
            
        }
    }
    
    func saveMovieWatchlist(id: Int, name: String) -> Bool {
        let request = NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
        let predicte = NSPredicate(format: "id == %@", NSNumber(value: id))
        request.predicate = predicte
        
        if let result = self.perform(fetchRequest: request, on: self.persistentContainer.viewContext)?.first {
            result.id = Int64(id)
            result.name = name
        } else {
            let entity = WatchlistMovie(context: self.persistentContainer.viewContext)
            entity.id = Int64(id)
            entity.name = name
        }
        
        do {
            try self.persistentContainer.viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func removeMovieWatchlist(id: Int) -> Bool {
        let request = NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
        let predicte = NSPredicate(format: "id == %@", NSNumber(value: id))
        request.predicate = predicte
        if let result = self.perform(fetchRequest: request, on: self.persistentContainer.viewContext)?.first {
            self.persistentContainer.viewContext.delete(result)
            do {
                try self.persistentContainer.viewContext.save()
                return true
            } catch {
                return false
            }
        } else {
            return true
        }
    }
    
    func getWatchlistMovies() -> [WatchlistMovie] {
        let request = NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
        let idSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSortDescriptor]
        if let result = self.perform(fetchRequest: request, on: self.persistentContainer.viewContext) {
            return result
        } else {
            return []
        }
    }
    
}
