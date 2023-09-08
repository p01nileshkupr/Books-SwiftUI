//
//  BooksListService.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/01.
//

import Foundation

class BooksListService: BooksListServiceProtocol {
    
    //MARK: - Fetch Books
    
    func fetchBooks() async throws -> [Book] {
        let resource = RequestConfig.Resource<BookResponse?>(
            urlPath: "/svc/books/v3/lists/full-overview.json?api-key=\(RequestConfig.Header.apiKeyValue)",
            method: .get
        ) { data in
            return BookResponse.decode(data)
        }

        let result = await NetworkManager.sharedNetworkManager.fetchData(resource: resource)
        
        switch result {
            case .success(let response): do {
                var books: [Book] = []
                guard response?.status == "OK" else { throw NetworkError.requestfailed }
                guard let results = response?.results else { throw NetworkError.requestfailed }
                guard let bookslist = results.lists?.compactMap({$0.books}) else { throw NetworkError.nodata }
                
                bookslist.forEach { list in
                    list.forEach { book in
                        guard books.contains(where: {
                            $0.bookUri == book.bookUri &&
                            $0.title == book.title &&
                            $0.author == book.author
                        }) == true else {
                            books.append(book)
                            return
                        }
                    }
                }

                guard books.count > 0 else { throw NetworkError.parsingfailed }

                return books
            }
            case .failure(let error):
                throw error
        }
    }
}
