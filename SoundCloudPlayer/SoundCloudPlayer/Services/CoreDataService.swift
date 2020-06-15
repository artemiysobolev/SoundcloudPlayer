//
//	CoreDataService.swift
// 	SoundCloudPlayer
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    private let cachedTrack = "CachedTrack"
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
    
    func saveTrackToDevice(_ track: Track, artworkImagePath: String?, audioFilePath: String?) {
        guard let entity = NSEntityDescription.entity(forEntityName: cachedTrack, in: context),
            let trackObject = NSManagedObject(entity: entity, insertInto: context) as? CachedTrack else { return }
        
        if let imagePath = artworkImagePath {
            trackObject.artworkImagePath = imagePath
        }
        
        if let audioPath = audioFilePath {
            trackObject.audioFilePath = audioPath
        } else {
            trackObject.audioFilePath = track.streamUrl
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
        return countRequest(predicate: NSPredicate(format: "id == %d", id)) == 0 ? false : true
    }
    
    func removeTrack(_ track: CachedTrack) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let relativePath = track.artworkImagePath,
            let url = URL(string: relativePath, relativeTo: documents),
            countRequest(predicate: NSPredicate(format: "artworkImagePath == %@", relativePath)) == 1 {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Image using by another track")
        }
        context.delete(track)
        saveContext()
    }
    
    private func countRequest(predicate: NSPredicate) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: cachedTrack)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]
        do {
            let result = try context.fetch(fetchRequest)
            return result.count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    private func saveContext () {
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
