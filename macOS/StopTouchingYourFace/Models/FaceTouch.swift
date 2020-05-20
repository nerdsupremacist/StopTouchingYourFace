
import Foundation
import GRDB

struct FaceTouch: Codable, TableRecord, PersistableRecord, FetchableRecord {
    let from: Date
    let to: Date

    var duration: TimeInterval {
        return from.distance(to: to)
    }
}

class FaceTouchDatabase {
    let databasePool: DatabasePool

    private(set) var faceTouches: [FaceTouch]

    init(databasePool: DatabasePool) throws {
        self.databasePool = databasePool
        try databasePool.write { database in
            try database.create(table: "faceTouch", ifNotExists: true) { table in
                table.column("id", .integer).primaryKey()
                table.column("from", .datetime)
                table.column("to", .datetime)
            }
        }
        faceTouches = try databasePool.read { try FaceTouch.fetchAll($0) }
    }

    func append(faceTouch: FaceTouch) throws {
        try databasePool.write { try faceTouch.insert($0) }
        faceTouches.append(faceTouch)
    }
}
