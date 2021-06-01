//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 31.05.2021.
//

import UIKit
import SVProgressHUD
import FirebaseAnalytics

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var director: UILabel!
    
    var movieName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.getMovieDetail()
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
    func getMovieDetail() {
        let clearString = movieName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        let postRequest = APIRequest(fullurl: "\(Config.API_URL)?t=\(clearString)&apikey=\(Config.API_KEY)")
               postRequest.post(completion: { result in
                   switch result {
                   case .success(let jsonData):
                       print("success")
                    do {
                        let movieData = try JSONDecoder().decode(MovieDetail.self, from: jsonData)
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.name.text = movieData.Title
                            self.year.text = movieData.Year
                            self.plot.text = movieData.Plot
                            self.awards.text = movieData.Awards
                            self.language.text = movieData.Language
                            self.country.text = movieData.Country
                            self.actors.text = movieData.Actors
                            self.imdbRating.text = movieData.imdbRating
                            self.genre.text = movieData.Genre
                            self.director.text = movieData.Director
                            self.downloadImage(from: (URL(string: movieData.Poster) ?? URL(string: Config.DEFAULT_IMG))!) { (img) in
                                self.poster.image = img
                            }
                            self.getFirebaseAnalytics(name: movieData.Title, year: movieData.Year, plot: movieData.Plot, award: movieData.Awards, language: movieData.Language, country: movieData.Country, actors: movieData.Actors, imdb: movieData.imdbRating, genre: movieData.Genre, director: movieData.Director)
                        }
                    }catch {
                        SVProgressHUD.dismiss()
                        self.showAlert(message: "Movie not found!")
                    }
                   case .failure(let error):
                        SVProgressHUD.dismiss()
                        self.showAlert(message: error.localizedDescription)
                   }
               })
    }
    
    func getFirebaseAnalytics(name: String, year: String, plot: String, award: String, language: String, country: String, actors: String, imdb: String, genre: String, director: String) {
        FirebaseAnalytics.Analytics.logEvent("detail_screen_viewed", parameters: [
          AnalyticsParameterScreenName: "product_detail_view",
            "movie_name": name,
            "movie_year": year,
            "movie_plot": plot,
            "movie_awards": award,
            "movie_language": language,
            "movie_country": country,
            "movie_actors": actors,
            "movie_imdbRating": imdb,
            "movie_genre": genre,
            "movie_director": director,
        ])

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MovieDetailVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell") as! MovieDetailCell
        return cell
    }
    
    
}
