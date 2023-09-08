//
//  BooksListServiceProtocol.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/01.
//

import Foundation

protocol BooksListServiceProtocol {
    func fetchBooks() async throws -> [Book]
}
