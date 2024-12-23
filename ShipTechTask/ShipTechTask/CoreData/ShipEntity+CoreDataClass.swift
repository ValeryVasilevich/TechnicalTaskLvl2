import Foundation
import CoreData

@objc(ShipEntity)
public final class ShipEntity: NSManagedObject {}

extension ShipEntity {
    convenience init(context: NSManagedObjectContext, with ship: Ship) {
        self.init(context: context)
        id = ship.id
        name = ship.name
        image = ship.image
        type = ship.type
        dateBuild = ship.dateBuild
    }
}

public extension ShipEntity {

    @nonobjc final class func fetchRequest() -> NSFetchRequest<ShipEntity> {
        NSFetchRequest<ShipEntity>(entityName: "ShipEntity")
    }

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var image: String?
    @NSManaged var type: String
    @NSManaged var dateBuild: Date?
}
