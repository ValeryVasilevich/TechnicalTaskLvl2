import Foundation
import CoreData

@objc(ShipEntity)
public class ShipEntity: NSManagedObject {}

extension ShipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShipEntity> {
        return NSFetchRequest<ShipEntity>(entityName: "ShipEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var type: String?
    @NSManaged public var year: Int16

    func update(from ship: Ship) {
        id = ship.id
        name = ship.name
        image = ship.image
        type = ship.type
        year = Int16(ship.year ?? 0)
    }
}

extension ShipEntity : Identifiable {}
