//
//  OrderController.swift
//  GetACook
//
//  Created by Jonathan on 06/06/2017.
//
//

import UIKit
import Firebase
import DatePickerDialog

class OrderController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var peopleField: UITextField!
    
    @IBOutlet weak var button12to14: UIButton!
    @IBOutlet weak var button17to19: UIButton!
    @IBOutlet weak var button19to21: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var dateFormatter: DateFormatter!
    
    var timeButtons = [UIButton]()
    
    var selectedDate: Date? = Date()
    var selectedTime: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set date formatter
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = Locale.current
        
        // Set date delegate
        dateField.delegate = self
        
        // Store button in array
        timeButtons += [button12to14, button17to19, button19to21]
        
        // Add UIToolBar on keyboard w/ Next button
        addNextButtonOnKeyboard()
        
        // Update submit button
        updateSubmitButton()
    }
    
    // MARK: Actions
    @IBAction func setTime12to14(_ sender: UIButton) {
        updateTime(value: 12, button: sender)
    }
    
    @IBAction func setTime17to19(_ sender: UIButton) {
        updateTime(value: 17, button: sender)
    }
    
    @IBAction func setTime19to21(_ sender: UIButton) {
        updateTime(value: 19, button: sender)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: On edit
    @IBAction func onEdit(_ sender: Any) {
        updateSubmitButton()
    }
    
    // MARK: Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Ensure keyboard is hidden
        textField.resignFirstResponder()
        
        // 1 week max date
        let maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        DatePickerDialog().show(title: "Date", doneButtonTitle: "Valider", cancelButtonTitle: "Annuler", minimumDate: Date(), maximumDate: maximumDate, datePickerMode: .date) {
            (date) -> Void in
            
            self.selectedDate = date
            if date != nil {
                textField.text = self.dateFormatter.string(from: date!).localizedCapitalized
            }
            
            self.updateSubmitButton()
        }
    
        return false
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "List" {
            guard let listController = segue.destination as? ListController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let order = Order(address: addressField.text!, people: Int(peopleField.text!)!, date: selectedDate!, time: selectedTime!)
            
            listController.order = order
        }
    }
    
    @IBAction func unwindToOrder(sender: UIStoryboardSegue) {
    }
    
    // MARK: Hide keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Private methods
    private func updateSubmitButton() {
        guard let charCount = addressField.text?.characters.count, charCount > 5 else {
            submitButton.isEnabled = false
            return
        }
        
        guard let people = Int(peopleField.text!), people > 0 && people < 20 else {
            submitButton.isEnabled = false
            return
        }

        if selectedDate == nil || selectedTime == nil {
            submitButton.isEnabled = false
            return
        }
        
        submitButton.isEnabled = true
    }
    
    private func addNextButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(nextButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        peopleField.inputAccessoryView = doneToolbar
    }
    
    func nextButtonAction() {
        view.endEditing(true)
    }
    
    private func updateTime(value: Int, button sender: UIButton) {
        let wasSenderSelected = sender.isSelected
        
        timeButtons.forEach { (button) in
            button.isSelected = false
        }
        
        sender.isSelected = !wasSenderSelected
        selectedTime = wasSenderSelected ? nil : value
        updateSubmitButton()
    }
}
