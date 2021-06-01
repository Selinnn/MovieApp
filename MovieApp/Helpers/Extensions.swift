//
//  Extensions.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 2.06.2021.
//

import Foundation

extension String {
    func convertToValidName() -> String {
        let invalidFileNameCharactersRegex = "[^a-zA-Z0-9_]+"
        let fullRange = startIndex..<endIndex
        let validName = replacingOccurrences(of: invalidFileNameCharactersRegex,
                                           with: "",
                                        options: .regularExpression,
                                          range: fullRange)
        return validName
    }
}
