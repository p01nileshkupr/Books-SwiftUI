//
//  RealmActor.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/08.
//

import Foundation
import RealmSwift

class RealmActor {
    // An implicitly-unwrapped optional is used here to let us pass `self` to
    // `Realm(actor:)` within `init`
    var realm: Realm!
    init() async throws {
        let identifier = "BooksRealm"
        var config = Realm.Configuration(inMemoryIdentifier: identifier)
        config.deleteRealmIfMigrationNeeded = true
        config.objectTypes = [BookObject.self]
        realm = try await Realm(configuration: config)
    }
    
    var count: Int {
        realm.objects(BookObject.self).count
    }
    
    var objects: Results<BookObject> {
        realm.objects(BookObject.self)
    }
    
    func add(book: BookObject) throws {
        try realm.write {
            realm.add(book)
        }
    }
    
    func deleteAllBooks() async throws {
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func close() {
        realm = nil
    }
}
