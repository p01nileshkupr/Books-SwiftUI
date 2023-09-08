//
//  BookDetailsHeaderViewModel.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/07.
//

import Foundation

struct BookDetailsHeaderViewModel {
    let book: BookViewModel
    
    init(book: BookViewModel) {
        self.book = book
    }
    
    var title: String { self.book.title }
    var image: String { self.book.bookImage }
    var contributor: String { self.book.contributor }
}
