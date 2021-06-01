//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 1.06.2021.
//

import Foundation
import FirebaseAnalytics

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailDelegate? {get set}
    func getMovieDetail(text: String)
    func firebaseAnalytics(movie: MovieDetail)
    
}

protocol MovieDetailDelegate: AnyObject {
    func showAlert(message: String)
    func setData(data: MovieDetail)
    func showProgress()
    func dismissProgress()
}

final class MovieDetailViewModel {
    weak var delegate: MovieDetailDelegate?
}

extension MovieDetailViewModel: MovieDetailViewModelProtocol {
    func getMovieDetail(text: String) {
        delegate?.showProgress()
        let clearString = text.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        let postRequest = APIRequest(fullurl: "\(Config.API_URL)?t=\(clearString)&apikey=\(Config.API_KEY)")
               postRequest.post(completion: { result in
                   switch result {
                   case .success(let jsonData):
                       print("success")
                    do {
                        let movieData = try JSONDecoder().decode(MovieDetail.self, from: jsonData)
                        self.delegate?.setData(data: movieData)
                        
                    }catch {
                        self.delegate?.dismissProgress()
                        self.delegate?.showAlert(message: "Movie not found!")
                    }
                   case .failure(let error):
                    self.delegate?.dismissProgress()
                    self.delegate?.showAlert(message: error.localizedDescription)
                   }
               })
    }
    
    func firebaseAnalytics(movie: MovieDetail) {
        FirebaseAnalytics.Analytics.logEvent("detail_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "product_detail_view",
            "movie_name": movie.Title,
            "movie_year": movie.Year,
            "movie_plot": movie.Plot,
            "movie_awards": movie.Awards,
            "movie_language": movie.Language,
            "movie_country": movie.Country,
            "movie_actors": movie.Actors,
            "movie_imdbRating": movie.imdbRating,
            "movie_genre": movie.Genre,
            "movie_director": movie.Director,
        ])

    }
    

}
