//
//  ProfileController.swift
//  GetACook
//
//  Created by Jonathan on 08/06/2017.
//
//

import UIKit

class ProfileController: UIViewController {
    
    // MARK: Properties
    var chief: Chief!
    var order: Order!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicture.image = chief?.photo
        nameLabel.text = chief?.name
        tagsLabel.text = chief?.tags.joined(separator: ", ")
        bioLabel.text = chief?.bio
        mealsLabel.text = chief?.meals.joined(separator: "\n")
    }

    @IBAction func orderButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Réservation réussie", message: "\(chief.name) préparera le repas pour \(order.people) personnes à \(order.address), \(order.getFormattedDate()) à \(order.time)h.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
