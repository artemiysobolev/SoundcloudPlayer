//
//	CoreDataService.swift
// 	SoundCloudPlayer
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveTrackToDevice(_ track: Track) {
        guard let entity = NSEntityDescription.entity(forEntityName: "CachedTrack", in: context),
            let trackObject = NSManagedObject(entity: entity, insertInto: context) as? CachedTrack else { return }
        
        if let urlString = track.artworkUrl,
            let url = URL(string: urlString) {
            trackObject.artworkImagePath = url
        }
        
        if let urlString = track.streamUrl,
            let url = URL(string: urlString) {
            trackObject.audioFilePath = url
        }
        
        if let genre = track.genre {
            trackObject.genre = genre
        }
        
        trackObject.duration = Int64(track.duration)
        trackObject.id = Int64(track.id)
        trackObject.title = track.title
        
        saveContext()
    }
    
    func fetchTracks() -> [CachedTrack] {
        let fetchRequest: NSFetchRequest<CachedTrack> = CachedTrack.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        var trackList: [CachedTrack] = []
        do {
            trackList = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return trackList
    }
        
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
