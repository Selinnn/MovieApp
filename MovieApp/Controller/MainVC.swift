//
//  MainVC.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import UIKit
import SVProgressHUD

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var movieTextField: UITextField!
    
    var movie = [Search]()
    var movieModel = [MovieModel]()
    var searchText = "Batman"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.getMovies()
    }
    
    func getMovies() {
        let postRequest = APIRequest(fullurl: "\(Config.API_URL)?s=\(searchText)&apikey=\(Config.API_KEY)")
               postRequest.post(completion: { result in
                   switch result {
                   case .success(let jsonData):
                       print("success")
                    do {
                        let movieData = try JSONDecoder().decode(Movie.self, from: jsonData)
                        self.movie = movieData.Search
                        DispatchQueue.main.async {
                            self.createModel()
                            SVProgressHUD.dismiss()
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
        searchBtn.isEnabled = true
    }
    
    func createModel() {
        movieModel.removeAll()
        for i in 0..<movie.count {
            let movies = movie[i]
            movieModel.append(MovieModel(title: movies.Title, year: movies.Year, imgUrl: movies.Poster))
           }
           self.tableView.reloadData()
       }
    
    @IBAction func searchAction(_ sender: Any) {
        if movieTextField.text != "" {
            SVProgressHUD.show()
            searchBtn.isEnabled = false
          let clearString = movieTextField.text!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
          searchText = clearString
          self.getMovies()
        }else {
            self.showAlert(message: "Please enter the movie name.")
        }
       
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
 }

extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        cell.movieViewModel = MovieViewModel(movieModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        newViewController.movieName = movieModel[indexPath.row].title
        newViewController.modalPresentationStyle = .fullScreen
        movieTextField.text = ""
        searchText = "Batman"
        self.present(newViewController, animated: true, completion: nil)
    }
}
