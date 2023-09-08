//
//  MockBooksListService.swift
//  BooksTests
//
//  Created by Nilesh Prajapati on 2023/09/07.
//

import Foundation

class MockBooksListService: BooksListServiceProtocol {
    
    //MARK: - Properties

    private(set) var mockData: [Book]
    private(set) var networkError: NetworkError?
    private(set) var isEmptyResponse: Bool = false

    //MARK: - init

    init(mockData: [Book] = [],
         networkError: NetworkError? = nil) {
        self.mockData = mockData
        self.networkError = networkError
     }
    
    //MARK: - Protocol Methods

    func fetchBooks() async throws -> [Book] {
        if let networkError = networkError {
            self.isEmptyResponse = true
            throw networkError
        } else if self.mockData.isEmpty {
            self.isEmptyResponse = true
            return self.mockData
        } else {
            return self.mockData
        }
    }
    
    //MARK: - deinit
    
    deinit {
        mockData.removeAll()
        networkError = nil
    }
}
