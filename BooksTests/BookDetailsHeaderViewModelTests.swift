//
//  BookDetailsHeaderViewModelTests.swift
//  BooksTests
//
//  Created by Nilesh Prajapati on 2023/09/07.
//

import XCTest

final class BookDetailsHeaderViewModelTests: XCTestCase {

    private var viewModel: BookDetailsHeaderViewModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = BookDetailsHeaderViewModel(book: BookViewModel(book: mockData.first!))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testBookPropertiesAvailability() {
        XCTAssertNotNil(viewModel?.title)
        XCTAssertNotNil(viewModel?.contributor)
        XCTAssertNotNil(viewModel?.image)
    }
    
    func testBookPropertiesNotEmpty() {
        XCTAssertEqual(viewModel?.title.isEmpty, false)
        XCTAssertEqual(viewModel?.contributor.isEmpty, false)
    }

    func testBookPropertiesEmpty() {
        XCTAssertEqual(viewModel?.image.isEmpty, true)
    }
}
