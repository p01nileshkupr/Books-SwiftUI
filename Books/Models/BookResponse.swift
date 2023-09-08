//
//  BookResponse.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

struct BookResponse: Decodable {
    let status: String?
    let copyright: String?
    let results: BookResult?
}

struct BookResult: Decodable {
    let lists: [BookList]?
}

struct BookList: Decodable {
    let listId: Int?
    let listName: String?
    let listNameEncoded: String?
    let displayName: String?
    let books: [Book]?
}
