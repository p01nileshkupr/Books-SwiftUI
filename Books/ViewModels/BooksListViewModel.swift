//
//  BooksListViewModel.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation
import SwiftUI
import RealmSwift

enum SortBy {
    case title
    case unknown
}

class BooksListViewModel: ObservableObject {

    //MARK: - Properties
    
    private lazy var relamConfig: Realm.Configuration = {
        let identifier = "Books"
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL?.deleteLastPathComponent()
        config.fileURL?.appendPathComponent(identifier)
        config.fileURL?.appendPathExtension("realm")
        return config
    }()
    
    private var service: BooksListServiceProtocol?
    private var books: [BookViewModel]? {
        didSet {
            setSearchResults()
        }
    }
    
    var searchText: String = "" {
        didSet {
            setSearchResults()
        }
    }
    var sortBy: SortBy = .unknown {
        didSet {
            guard sortBy != .unknown else {
                searchResults = books
                return
            }

            searchResults = searchResults?.sorted(by: {$0.title < $1.title})
        }
    }
    
    @Published var searchResults: [BookViewModel]?
    @Published var serviceState: NetworkServiceState
    @Published var networkError: NetworkError?

    //MARK: - init
    
    private init(serviceState: NetworkServiceState = .notyetstarted,
                 networkError: NetworkError? = nil) {
        self.serviceState = serviceState
        self.networkError = networkError
    }

    convenience init(service: BooksListServiceProtocol) {
        self.init()
        self.service = service
    }
        
    //MARK: - Methods
    
    func setSearchResults() {
        guard !searchText.isEmpty else {
            guard sortBy != .unknown else {
                searchResults = books
                return
            }

            searchResults = books?.sorted(by: {$0.title < $1.title})
            return
        }
        print("SearchText: \(searchText)")

        guard sortBy != .unknown else {
            searchResults = books?.filter({$0.title.contains(searchText)})
            return
        }
        
        self.searchResults = books?.filter({$0.title.contains(searchText)}).sorted(by: { book1, book2 in
            return book1.title < book2.title
        })
    }
    
    func setSort(by type: SortBy) {
        self.sortBy = type
    }
    
    //MARK: - Fetch Books
    
    func fetchRealmDataIfAvailable() async -> [BookViewModel]? {
        do {
            let realm = try await Realm(configuration: relamConfig)
            let realmObjects = realm.objects(BookObject.self)
            
            guard realmObjects.count > 0 else {
                return nil
            }

            return realmObjects.compactMap({BookViewModel(book: $0.original())})
        } catch {
            return nil
        }
    }
    
    @MainActor
    func fetchBooks() async {
        serviceState = .inprogress
        
        //TO skip the testing of Realm DB
        if NSClassFromString("XCTestCase") == nil {
            guard let list = await fetchRealmDataIfAvailable(), list.isEmpty else {
                let list = await fetchRealmDataIfAvailable()
                self.books = list
                serviceState = .succeed
                return
            }
        }
        
        do {
            guard let list = try await service?.fetchBooks(), !list.isEmpty else {
                serviceState = .failed
                networkError = .nodata
                return
            }

            let realm = try await Realm(configuration: relamConfig)

            try realm.write {
                list.forEach({ book in
                    realm.add(book.object(), update: .modified)
                })
            }

            self.books = list.compactMap({BookViewModel(book: $0)})
            serviceState = .succeed
        } catch {
            serviceState = .failed
            networkError = error as? NetworkError
        }
    }
    
    //MARK: - Refresh Books List

    @MainActor
    func refreshBooks() async {
        serviceState = .inprogress

        do {
            let realm = try await Realm(configuration: relamConfig)
            guard realm.objects(BookObject.self).count > 0 else {
                await fetchBookFromServer()
                return
            }
            
            try realm.write({
                realm.deleteAll()
            })

            books?.removeAll()
            
            await fetchBookFromServer()
        } catch {
            print(error.localizedDescription)
        }
    }

    //MARK: - Service calls

    @MainActor
    func fetchBookFromServer() async {
        do {
            guard let list = try await service?.fetchBooks(), !list.isEmpty else {
                serviceState = .failed
                networkError = .nodata
                return
            }

            let realm = try await Realm(configuration: relamConfig)
            try realm.write {
                list.forEach({ book in
                    realm.add(book.object(), update: .modified)
                })
            }

            self.books = list.compactMap({BookViewModel(book: $0)})
            serviceState = .succeed
        } catch {
            serviceState = .failed
            networkError = error as? NetworkError
        }
    }
    
    //MARK: - deinit
    
    deinit {
        service = nil
        books?.removeAll()
        books = nil
        networkError = nil
        searchResults?.removeAll()
        searchResults = nil
    }
}
