//
//  LoginController.swift
//  GetACook
//
//  Created by Jonathan on 04/06/2017.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var ref: DatabaseReference!
    
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                print("FIREBASE: User logged..")
                
                self.ref.child("users/\(user!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let enabled = snapshot.childSnapshot(forPath: "enabled").value as? Bool, enabled == true else {
                        print("FIREBASE: Disabled user")
                        user?.delete(completion: nil)
                        let alert = UIAlertController(title: "Erreur", message: "Vous devez déjà vous inscrire.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    guard let name = snapshot.childSnapshot(forPath: "name").value as? String else {
                        fatalError("FIREBASE: Enabled account without name")
                    }
                    
                    print("FIREBASE: Login completed!")
                    let alert = UIAlertController(title: "Connexion réussie", message: "Bon appétit \(name) !", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: {
                        (result : UIAlertAction) -> Void in
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation")
                        self.present(vc!, animated: true, completion: nil)
                        
                    })
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            
            } else {
                let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
