//
//  String+Extensions.swift
//  Books
//
//  Created by Nilesh Prajapati on 2023/09/06.
//

import Foundation

extension String {

    func localised() -> String {
        NSLocalizedString(self, comment: self)
    }
}
