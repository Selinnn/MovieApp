//
//  Movie.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import Foundation

struct Movie: Decodable {
    var Search: [Search]
}

struct Search: Decodable {
    var Title: String
    var Year: String
    var Poster: String
}
