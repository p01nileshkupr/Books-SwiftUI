//
//  BooksListRowView.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import SwiftUI

struct BooksListRowView: View {
    
    //MARK: - Properties
    
    let viewModel: BooksListRowViewModel
    
    //MARK: - Body
    
    var body: some View {
        HStack(alignment: .center) {
            BookImageView(image: viewModel.image)
                .frame(width: 80, height: 120)
                .shadow(radius: 5)
                .shadow(color: .primary, radius: 5, x: 0, y: 5)

            VStack(alignment: .leading) {
                Text("\(viewModel.title)")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
                
                Text(viewModel.contributor)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding()
        }
    }
}

//MARK: - Preview

struct BooksListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let bookModel = BookViewModel(book: mockData.first!)
        let rowViewModel = BooksListRowViewModel(book: bookModel)
        BooksListRowView(viewModel: rowViewModel)
            .previewLayout(.sizeThatFits)
    }
}
