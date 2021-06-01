//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 31.05.2021.
//

import UIKit
import SVProgressHUD
import SDWebImage


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
    
    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var movieName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel = MovieDetailViewModel()
        viewModel.getMovieDetail(text: movieName)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MovieDetailVC: MovieDetailDelegate {
    func showProgress() {
        SVProgressHUD.show()
    }
    
    func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    func setData(data: MovieDetail) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.name.text = data.Title
            self.year.text = data.Year
            self.plot.text = data.Plot
            self.awards.text = data.Awards
            self.language.text = data.Language
            self.country.text = data.Country
            self.actors.text = data.Actors
            self.imdbRating.text = data.imdbRating
            self.genre.text = data.Genre
            self.director.text = data.Director
            self.poster.sd_setImage(with: URL(string: data.Poster), completed: nil)
            
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension MovieDetailVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath) 
        return cell
    }
    
    
}
