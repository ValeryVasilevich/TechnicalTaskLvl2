import Foundation
import CoreData

@objc(ShipEntity)
public class ShipEntity: NSManagedObject {}

extension ShipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShipEntity> {
        NSFetchRequest<ShipEntity>(entityName: "ShipEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var image: String?
    @NSManaged public var type: String
    @NSManaged public var dateBuild: Date?

    convenience init(context: NSManagedObjectContext, with ship: Ship) {
        self.init(context: context)
        id = ship.id
        name = ship.name
        image = ship.image
        type = ship.type
        dateBuild = ship.dateBuild
    }
}

extension ShipEntity : Identifiable {}
