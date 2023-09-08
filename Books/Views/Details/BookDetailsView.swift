//
//  BookDetailsView.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import SwiftUI
import Collections

struct BookDetailsView: View {
    
    //MARK: - Properties
    
    var viewModel: BookDetailsViewModel
    
    private var list: OrderedDictionary<String, String> {
        return [
            "Publisher".localised(): viewModel.publisher,
            "Author".localised(): viewModel.author,
            "BookDetailsCreatedDateTitleText".localised(): viewModel.createdDate,
        ]
    }
    
    //MARK: - Body
    
    var body: some View {
        List {
            //Header View
            let headerViewModel = BookDetailsHeaderViewModel(book: viewModel.book)
            BookDetailsHeaderView(viewModel: headerViewModel)

            if !viewModel.description.isEmpty {
                //Short Description Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("BookDetailsShortDescriptionTitleText".localised())
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.accentColor)

                    Text(viewModel.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }//: VSTACK
            }
            
            //Details Section
            VStack(alignment: .leading) {
                Text("BookDetailsTitleText".localised())
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.accentColor)

                HStack(alignment: .firstTextBaseline) {
                    //Left side title
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(list.elements, id: \.key) { item in
                            Text(item.key)
                                .font(.subheadline)
                        }
                    }//: VStack
                    .padding(.horizontal, 10)
                    
                    //Right side value
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(list.elements, id: \.key) { item in
                            Text(item.value)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }//: VStack
                    .padding(.horizontal, 10)

                }//: HStack
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
            }//: VSTACK
        }
        .navigationTitle("BookDetailsTitle".localised())
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, 1.0)
    }
}

//MARK: - Preview

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BookViewModel(book: mockData.first!)
        BookDetailsView(viewModel: BookDetailsViewModel(book: viewModel))
    }
}
