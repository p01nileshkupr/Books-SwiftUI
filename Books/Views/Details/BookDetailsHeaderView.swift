//
//  BookDetailsHeaderView.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import SwiftUI

struct BookDetailsHeaderView: View {
    
    //MARK: - Properties
    
    var viewModel: BookDetailsHeaderViewModel
    
    //MARK: - Body
    
    var body: some View {
        VStack(alignment: .center) {
            BookImageView(image: viewModel.image)
                .padding(30.0)
                .shadow(radius: 5)
                .shadow(color: .primary, radius: 5, x: 0, y: 5)

            VStack(alignment: .center, spacing: 5.0) {
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
                
                Text(viewModel.contributor)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }//: VStack
            .padding(.horizontal, 10.0)
            .padding(.bottom, 20)
        }
    }
}

//MARK: - Preview

struct BookDetailsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookViewModel(book: mockData.first!)
        let viewModel = BookDetailsHeaderViewModel(book: book)
        BookDetailsHeaderView(viewModel: viewModel)
            .previewLayout(.fixed(width: 375, height: 185))
    }
}

