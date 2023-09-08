//
//  BookViewModel.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

struct BookViewModel {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    var bookUri: String {
        self.book.bookUri ?? ""
    }
    
    var title: String {
        self.book.title ?? ""
    }
    
    var description: String {
        self.book.description ?? ""
    }
    
    var bookImage: String {
        self.book.bookImage ?? ""
    }

    var rank: Int {
        self.book.rank ?? 0
    }
    
    var author: String {
        self.book.author ?? ""
    }
    
    var contributor: String {
        self.book.contributor ?? ""
    }
    
    var createdDate: String {
        self.book.createdDate ?? ""
    }

    var publisher: String {
        self.book.publisher ?? ""
    }
    
}
