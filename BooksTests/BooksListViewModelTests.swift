//
//  BooksListViewModelTests.swift
//  BooksTests
//
//  Created by Nilesh Prajapati on 2023/09/07.
//

import XCTest

final class BooksListViewModelTests: XCTestCase {

    private var viewModel: BooksListViewModel?
    private var mockService: MockBooksListService?
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockService = nil
    }
    
    func testMoviesServiceSuccess() async {
        mockService = MockBooksListService(mockData: mockData)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .succeed)
        XCTAssertNil(viewModel?.networkError)
        XCTAssertNotNil(viewModel?.searchResults)
        XCTAssertNotNil(viewModel?.searchResults?.map({$0.bookUri}))
        XCTAssertEqual(viewModel?.searchResults?.count, 174)
        XCTAssertEqual(viewModel?.sortBy, .unknown)
        XCTAssertNil(mockService.networkError)
        XCTAssertEqual(mockService.isEmptyResponse, false)
    }
    
    func testMoviesServiceWithEmptyResponse() async {
        mockService = MockBooksListService()
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }

        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertNotNil(viewModel?.networkError)
        XCTAssertEqual(viewModel?.networkError, .nodata)
        XCTAssertNil(viewModel?.searchResults)
        XCTAssertEqual(viewModel?.sortBy, .unknown)
        XCTAssertNil(mockService.networkError)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testMoviesServiceUrlFailure() async {
        mockService = MockBooksListService(networkError: .urlfailure)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }

        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertEqual(viewModel?.networkError, .urlfailure)
        XCTAssertEqual(mockService.networkError, .urlfailure)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testMoviesServiceFailureForNoData() async {
        mockService = MockBooksListService(networkError: .nodata)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertEqual(viewModel?.networkError, .nodata)
        XCTAssertEqual(mockService.networkError, .nodata)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testMoviesServiceFailureForNoResponse() async {
        mockService = MockBooksListService(networkError: .noresponse)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertEqual(viewModel?.networkError, .noresponse)
        XCTAssertEqual(mockService.networkError, .noresponse)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testMoviesServiceFailureForRequestFailed() async {
        mockService = MockBooksListService(networkError: .requestfailed)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertEqual(viewModel?.networkError, .requestfailed)
        XCTAssertEqual(mockService.networkError, .requestfailed)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testMoviesServiceFailureForParsingFailed() async {
        mockService = MockBooksListService(networkError: .parsingfailed)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .failed)
        XCTAssertEqual(viewModel?.networkError, .parsingfailed)
        XCTAssertEqual(mockService.networkError, .parsingfailed)
        XCTAssertTrue(mockService.isEmptyResponse)
    }
    
    func testSoryBy() {
        viewModel = BooksListViewModel(service: MockBooksListService())
        XCTAssertNotNil(viewModel?.sortBy)
        XCTAssertEqual(viewModel?.sortBy, .unknown)
        
        viewModel?.setSort(by: .title)
        XCTAssertEqual(viewModel?.sortBy, .title)
        
        viewModel?.setSort(by: .unknown)
        XCTAssertEqual(viewModel?.sortBy, .unknown)
    }
    
    func testSearchTextResults() async {
        mockService = MockBooksListService(mockData: mockData)
        guard let mockService else {
            XCTFail("Couldn't create mock service")
            return
        }
        viewModel = BooksListViewModel(service: mockService)

        await viewModel?.fetchBooks()
        
        XCTAssertEqual(viewModel?.serviceState, .succeed)
        XCTAssertNil(viewModel?.networkError)
        XCTAssertNotNil(viewModel?.searchResults)
        XCTAssertEqual(viewModel?.searchResults?.count, 174)

        viewModel?.searchText = "TOM"
        
        XCTAssertEqual(viewModel?.searchResults?.count, 3)
    }

}
