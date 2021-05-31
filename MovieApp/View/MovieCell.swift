//
//  MovieCell.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 31.05.2021.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    var movieViewModel : MovieViewModel! {
        didSet {
            
            downloadImage(from: movieViewModel.img, completion: {(img) in
                self.moviePoster.image = img
            })
            movieName.text = movieViewModel.title
            movieYear.text = movieViewModel.year
        }
    }

   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
     func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
        
    }
}
