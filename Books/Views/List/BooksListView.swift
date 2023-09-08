//
//  BooksListView.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import SwiftUI

struct BooksListView: View {
    
    //MARK: - Properties

    @ObservedObject private var viewModel = BooksListViewModel(service: BooksListService())
    
    //MARK: - Methods

    private func sort(by option: SortBy) {
        self.viewModel.setSort(by: option)
    }

    //MARK: - Body
    
    var body: some View {
        NavigationView(content: {
            VStack {
                if viewModel.serviceState == .failed || viewModel.serviceState == .unknown {
                    Text(viewModel.networkError?.localizedDescription ?? "Service failure")
                } else if viewModel.serviceState == .succeed, let books = viewModel.searchResults {
                    List(books, id:\.bookUri) { item in
                        //Destination details view for
                        let detailsView = BookDetailsView(viewModel: BookDetailsViewModel(book: item))
                        //Row view for each movie record
                        let listRowView = BooksListRowView(viewModel: BooksListRowViewModel(book: item))
                        NavigationLink<BooksListRowView, BookDetailsView>(destination: detailsView) {
                            listRowView
                        }//: NavigationLink
                    }
                    .searchable(text: $viewModel.searchText, prompt: "BooksListSearchBarPlaceholderText".localised())
                    .refreshable {
                        Task {
                            await viewModel.refreshBooks()
                        }
                    }
                } else {
                    VStack {
                        Text("BooksListActivityIndicatorTitle".localised())
                    }//:VStack
                    .frame(width: 150.0,
                           height: 150.0)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                }
            }
            .padding(.bottom, 1.0)
            .listStyle(.plain)
            .navigationTitle("BooksListTitle".localised())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task {
                            await viewModel.refreshBooks()
                        }
                    }) {
                        Text("BooksListRefreshButtonTitleText".localised())
                    }
                    .disabled(viewModel.serviceState == .inprogress)
                }//:Refresh
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("BooksListMenuTitle".localised()) {
                        Button(action: {sort(by: .unknown)}) {
                            Text("BooksListMenu1Title".localised())
                            Image(systemName: viewModel.sortBy == .unknown ? "circle.fill" : "circle")
                        }
                        Button(action: {sort(by: .title)}) {
                            Text("BooksListMenu2Title".localised())
                            Image(systemName: viewModel.sortBy == .title ? "circle.fill" : "circle")
                        }
                        Button(action: {}) {
                            Text("BooksListMenuCancel".localised())
                        }
                    }//:Sort Menu
                    .disabled(viewModel.serviceState != .succeed)
                }//: ToolBarItem
            }
        })
        .onAppear {
            Task {
                await viewModel.fetchBooks()
            }
        }
    }
}

//MARK: - Preview

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView()
    }
}
