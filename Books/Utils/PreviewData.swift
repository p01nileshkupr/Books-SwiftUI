//
//  PreviewData.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

var mockData: [Book] = {
    var books: [Book] = []
    var response: BookResponse { Bundle.main.decode("books.json")! }
    
    guard response.status == "OK" else { return books }
    guard let results = response.results else { return books }
    guard let bookslist = results.lists?.compactMap({$0.books}) else { return books }
    
    bookslist.forEach { list in
        list.forEach { book in
            guard books.contains(where: {$0.bookUri == book.bookUri && $0.title == book.title}) == true else {
                books.append(book)
                return
            }
        }
    }

    return books
}()
