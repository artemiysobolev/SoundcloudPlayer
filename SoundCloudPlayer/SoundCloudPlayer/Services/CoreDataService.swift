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
    
    func saveTrackToDevice(_ track: Track, artworkImagePath: URL?, audioFilePath: URL?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "CachedTrack", in: context),
            let trackObject = NSManagedObject(entity: entity, insertInto: context) as? CachedTrack else { return }
        
        if let imagePath = artworkImagePath {
            trackObject.artworkImagePath = imagePath
        }
        
        if let audioPath = audioFilePath {
            trackObject.audioFilePath = audioPath
        } else {
            trackObject.audioFilePath = URL(string: track.streamUrl!)
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

    func isTrackCached(with id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedTrack")
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int64(id))
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]
        do {
            let track = try context.fetch(fetchRequest)
            return !track.isEmpty
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func removeTrack(_ track: CachedTrack) {
        if let path = track.artworkImagePath {
            do {
                try FileManager.default.removeItem(at: path)
            } catch {
                print(error.localizedDescription)
            }
        }
        context.delete(track)
        saveContext()
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
