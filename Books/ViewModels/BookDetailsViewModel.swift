//
//  BookDetailsViewModel.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

struct BookDetailsViewModel {
    let book: BookViewModel
    
    init(book: BookViewModel) {
        self.book = book
    }
    
    var title: String {
        self.book.title
    }
    
    var description: String {
        self.book.description
    }
    
    var bookImage: String {
        self.book.bookImage
    }

    var rank: Int {
        self.book.rank
    }

    var author: String {
        self.book.author
    }
    
    var contributor: String {
        self.book.contributor
    }
    
    var createdDate: String {
        self.book.createdDate
    }
    
    var publisher: String {
        self.book.publisher
    }
}
