//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 1.06.2021.
//

import Foundation

struct MovieDetail: Decodable {
    var Title: String
    var Year: String
    var Genre: String
    var Director: String
    var Actors: String
    var Plot: String
    var Language: String
    var Country: String
    var Awards: String
    var Poster: String
    var imdbRating: String
}
