//
//  CoreDataHelper.swift
//  AirlineInfo
//
//  Created by Anas Salah on 07/08/2024.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AirlineInfo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchFavorites() -> Set<String> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Airline> = Airline.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return Set(results.compactMap { $0.name })
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    func addFavorite(name: String, site: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Airline> = Airline.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND site == %@", name, site)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                let airline = Airline(context: context)
                airline.name = name
                airline.site = site
                saveContext()
            }
        } catch {
            print("Failed to add favorite: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(name: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Airline> = Airline.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            saveContext()
        } catch {
            print("Failed to remove favorite: \(error.localizedDescription)")
        }
    }
}
