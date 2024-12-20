import CoreData

protocol LocalStorageManager {
    func fetchShips() async throws -> [Ship]
    func fetchShip(by id: String) async throws -> Ship?
    func saveShips(_ ships: [Ship]) async throws
    func deleteShip(by id: String) async throws
}

final class ShipsStorageManager: LocalStorageManager {
    static let shared = ShipsStorageManager()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShipTechTask")
        container.loadPersistentStores { _, error in
            guard let error else { return }
            self.handleCoreDataError(error)
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                self.handleCoreDataError(nserror)
            }
        }
    }

    // MARK: - LocalStorageManager methods

    func fetchShips() async throws -> [Ship] {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ShipEntity.name), ascending: true)]

        let entities = try context.fetch(fetchRequest)
        return entities.map { Ship(entity: $0) }
    }

    func fetchShip(by id: String) async throws -> Ship? {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        guard let entity = try context.fetch(fetchRequest).first else {
            return nil
        }

        return Ship(entity: entity)
    }


    func saveShips(_ ships: [Ship]) async throws {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        let existingEntities = try context.fetch(fetchRequest)

        var existingEntitiesDict = Dictionary(uniqueKeysWithValues: existingEntities.map { ($0.id ?? "", $0) })

        for ship in ships {
            let entity = existingEntitiesDict[ship.id] ?? ShipEntity(context: context)
            entity.update(from: ship)
            existingEntitiesDict.removeValue(forKey: ship.id)
        }

        for (_, entity) in existingEntitiesDict {
            context.delete(entity)
        }

        saveContext()
    }

    func deleteShip(by id: String) async throws {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        let entities = try context.fetch(fetchRequest)
        for entity in entities {
            context.delete(entity)
        }

        saveContext()
    }
}

// MARK: - Core Data Error Handling

private extension ShipsStorageManager {
    func handleCoreDataError(_ error: Error) {
        print("Core Data error: \(error.localizedDescription)")
        throw AppError.failedToLoadPersistentStores(error.localizedDescription)
    }
}
