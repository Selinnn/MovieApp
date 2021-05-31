//
//  MainVC.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieTextField: UITextField!
    
    var movie = [Search]()
    var movieModel = [MovieModel]()
    var searchText = "Batman"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getMovies()
    }
    
    func getMovies() {
        let postRequest = APIRequest(fullurl: "\(Config.API_URL)?s=\(searchText)&apikey=\(Config.API_KEY)")
               postRequest.post(completion: { result in
                   switch result {
                   case .success(let movies):
                       print("success")
                    self.movie = movies.Search
                    print(self.movie)
                       DispatchQueue.main.async {
                        self.createModel()
                       }
                   case .failure(let error):
                       print("failure \(error)")
                   }
               })
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
        searchText = movieTextField.text ?? ""
        self.getMovies()
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
}
