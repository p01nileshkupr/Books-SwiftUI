//
//  Book.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation
import RealmSwift

struct Book: Decodable, Hashable {
    let bookUri: String?
    let rank: Int?
    let title: String?
    let bookImage: String?
    let publisher: String?
    let description: String?
    let createdDate: String?
    let author: String?
    let amazonProductUrl: String?
    let contributor: String?
}

class BookObject: Object {
    @Persisted(primaryKey: true) var bookUri: String?
    @Persisted var rank: Int?
    @Persisted var title: String?
    @Persisted var bookImage: String?
    @Persisted var publisher: String?
    @Persisted var shortdescription: String?
    @Persisted var createdDate: String?
    @Persisted var author: String?
    @Persisted var amazonProductUrl: String?
    @Persisted var contributor: String?

    func original() -> Book {
        return Book(object: self)
    }
}

protocol Persistable {
    associatedtype Object: RealmSwift.Object

    init(object: Object)
    func object() -> Object
}

extension Book: Persistable {
    init(object: BookObject) {
        bookUri = object.bookUri
        rank = object.rank
        title = object.title
        bookImage = object.bookImage
        publisher = object.publisher
        description = object.shortdescription
        createdDate = object.createdDate
        author = object.author
        amazonProductUrl = object.amazonProductUrl
        contributor = object.contributor
    }
    
    func object() -> BookObject {
        let book = BookObject()
        book.bookUri = bookUri
        book.rank = rank
        book.title = title
        book.bookImage = bookImage
        book.publisher = publisher
        book.shortdescription = description
        book.createdDate = createdDate
        book.author = author
        book.amazonProductUrl = amazonProductUrl
        book.contributor = contributor
        return book
    }
}
