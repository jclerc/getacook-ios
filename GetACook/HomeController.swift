//
//  ViewController.swift
//  GetACook
//
//  Created by Jonathan on 18/05/2017.
//
//

import UIKit
import Firebase
import FirebaseAuth

class HomeController: UIViewController {

    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init loader
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()

        Auth.auth().addStateDidChangeListener { auth, user in
            self.activityView.stopAnimating()
            
            if user != nil {
                // User is signed in.
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation")
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
    }

}

