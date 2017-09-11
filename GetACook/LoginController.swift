//
//  LoginController.swift
//  GetACook
//
//  Created by Jonathan on 04/06/2017.
//
//

import UIKit
import Firebase
import MBProgressHUD

class LoginController: UIViewController {

    // MARK: Properties
    var ref: DatabaseReference!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init firebase
        ref = Database.database().reference()
    }
    
    // MARK: Actions
    @IBAction func loginButton(_ sender: UIButton) {        
        guard let email = emailField.text, email.characters.count > 5 && email.contains("@") else {
            wrongField(message: "L'email est incorrect.", input: emailField)
            return
        }
        
        guard let password = passwordField.text, password.characters.count > 5 else {
            wrongField(message: "Le mot de passe doit faire minimum 6 caractères.", input: passwordField)
            return
        }
        
        // Loading
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        sender.isEnabled = false
        
        // Login
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                // User logged via Firebase
                
                self.ref.child("users/\(user!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let enabled = snapshot.childSnapshot(forPath: "enabled").value as? Bool, enabled == true else {
                        // FIREBASE: Incorrect user
                        progress.hide(animated: true)
                        sender.isEnabled = true
                        
                        // Delete it
                        user?.delete(completion: nil)
                        
                        // And print alert
                        let alert = UIAlertController(title: "Erreur", message: "Vous devez déjà vous inscrire.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    guard let name = snapshot.childSnapshot(forPath: "name").value as? String else {
                        fatalError("FIREBASE: Enabled account without name")
                    }
                    
                    // Login completed!
                    progress.hide(animated: true)
                    sender.isEnabled = true
                    
                    // Print success
                    let alert = UIAlertController(title: "Connexion réussie", message: "Bon appétit \(name) !", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: {
                        (result : UIAlertAction) -> Void in
                        
                        // Then go to main navigation
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation")
                        self.present(vc!, animated: true, completion: nil)
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            
            } else {
                // Wrong credentials
                progress.hide(animated: true)
                sender.isEnabled = true
                
                let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    // MARK: Hide keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Private methods
    private func wrongField(message: String, input: UITextField) {
        let alert = UIAlertController(title: "Champ incorrect", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            (result : UIAlertAction) -> Void in input.becomeFirstResponder()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
