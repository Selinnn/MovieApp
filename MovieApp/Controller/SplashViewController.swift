//
//  SplashViewController.swift
//  MovieApp
//
//  Created by Selin KAPLAN on 30.05.2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = Reach().connectionStatus()

        switch status {
        case .unknown, .offline:
            self.showAlert(message: "You are not connected to the internet.")
        case .online:
            print("Connected")
            if Config.SPLASH_TEXT != "" {
                splashLabel.text = Config.SPLASH_TEXT
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.goMainVC()
                }
            }
        }
        
    }
    
    func goMainVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
