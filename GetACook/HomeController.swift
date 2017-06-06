//
//  ViewController.swift
//  GetACook
//
//  Created by Jonathan on 18/05/2017.
//
//

import UIKit
import Firebase
import MBProgressHUD

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)

        Auth.auth().addStateDidChangeListener { auth, user in
            progress.hide(animated: true)
            
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

