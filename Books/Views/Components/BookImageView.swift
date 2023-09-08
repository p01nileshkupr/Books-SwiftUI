//
//  BookImageView.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import SwiftUI

struct BookImageView: View {
    
    var image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
                    .scaledToFill()
            } else if phase.error != nil {
                Color.red // Indicates an error.
            } else {
                Color.secondary// Acts as a placeholder.
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct BookImageView_Previews: PreviewProvider {
    static var previews: some View {
        BookImageView(image: "https://storage.googleapis.com/du-prd/books/images/9780593441275.jpg")
    }
}
