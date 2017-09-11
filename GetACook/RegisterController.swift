//
//  RegisterController.swift
//  GetACook
//
//  Created by Jonathan on 04/06/2017.
//
//

import UIKit
import Firebase
import MBProgressHUD

class RegisterController: UIViewController {
    
    // MARK: Properties
    var ref: DatabaseReference!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add UIToolBar on keyboard w/ Done button
        addDoneButtonOnKeyboard()
        
        // Init firebase
        ref = Database.database().reference()
    }
    
    // MARK: Actions
    @IBAction func registerButton(_ sender: UIButton?) {
        guard let name = nameField.text, name.characters.count > 3 else {
            wrongField(message: "Le nom est incorrect.", input: nameField)
            return
        }
        
        guard let email = emailField.text, email.characters.count > 5 && email.contains("@") else {
            wrongField(message: "L'email est incorrect.", input: emailField)
            return
        }
        
        guard let password = passwordField.text, password.characters.count > 5 else {
            wrongField(message: "Le mot de passe doit faire minimum 6 caractères.", input: passwordField)
            return
        }
        
        guard let phone = phoneField.text, phone.characters.count >= 10 else {
            wrongField(message: "Le numéro de téléphone est incorrect.", input: phoneField)
            return
        }
        
        // Loading
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        sender?.isEnabled = false
        
        // Register
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                // User registered via Firebase
                // Now we fill its profile
                self.ref.updateChildValues([
                    "users/\(user!.uid)/name": name,
                    "users/\(user!.uid)/phone": phone,
                    "users/\(user!.uid)/enabled": true,
                    ], withCompletionBlock: { (error, reference) in
                        if (error != nil) {
                            // Can't complete profile: cancel registration
                            user?.delete(completion: nil)
                            
                            // No longer loading
                            progress.hide(animated: true)
                            sender?.isEnabled = true
                            
                            // Alert user
                            let alert = UIAlertController(title: "Erreur", message: "L'inscription a échouée..", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            // No longer loading
                            progress.hide(animated: true)
                            sender?.isEnabled = true
                            
                            // Registration is now complete!
                            let alert = UIAlertController(title: "Inscription réussie", message: "Bon appétit \(name) !", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "OK", style: .default, handler: {
                                (result : UIAlertAction) -> Void in
                
                                // Then go to main navigation
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigation")
                                self.present(vc!, animated: true, completion: nil)

                            })
                            
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                })
                
            } else {
                // Wrong credentials
                progress.hide(animated: true)
                sender?.isEnabled = true
                
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
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "S'inscrire", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegisterController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        phoneField.resignFirstResponder()
        registerButton(nil)
    }
    
    private func wrongField(message: String, input: UITextField) {
        let alert = UIAlertController(title: "Champ incorrect", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            (result : UIAlertAction) -> Void in input.becomeFirstResponder()
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
