import CoreData

protocol LocalStorageManager {
    func fetchShips() async throws -> [Ship]
    func fetchShip(by id: String) async throws -> Ship?
    func saveShips(_ ships: [Ship]) async throws
    func deleteShip(by id: String) async throws
}

final class ShipsStorageManager: LocalStorageManager {
    static let shared = ShipsStorageManager()

    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initializer

    init(storeType: String = NSSQLiteStoreType) {
        self.persistentContainer = ShipsStorageManager.setupPersistentContainer(storeType: storeType)
    }

    // MARK: - Core Data Setup

    private static func setupPersistentContainer(storeType: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ShipTechTask")
        let description = NSPersistentStoreDescription()
        description.type = storeType

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            guard let error else { return }
            fatalError("Failed to load persistent stores: \(error)")
        }

        return container
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }

    // MARK: - LocalStorageManager methods

    func fetchShips() async throws -> [Ship] {
        let fetchRequest: NSFetchRequest<ShipEntity> = ShipEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ShipEntity.name), ascending: true)]

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

        let existingEntitiesDictionary = Dictionary(uniqueKeysWithValues: existingEntities.map { ($0.id, $0) })

        for ship in ships {
            if let existingEntity = existingEntitiesDictionary[ship.id] {
                existingEntity.name = ship.name
                existingEntity.image = ship.image
                existingEntity.type = ship.type
                existingEntity.dateBuild = ship.dateBuild
            } else {
                ShipEntity(context: context, with: ship)
            }
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
