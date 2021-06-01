//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 31.05.2021.
//

import Foundation

struct MovieViewModel {
    
    var img: URL
    var title: String
    var year: String
    
    init(_ movieModel: MovieModel) {
        self.img = URL(string: movieModel.imgUrl) ?? URL(string: Config.DEFAULT_IMG)!
        self.title = movieModel.title
        self.year = movieModel.year
    }
    
    
}
