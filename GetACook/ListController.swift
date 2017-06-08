//
//  ListController.swift
//  GetACook
//
//  Created by Jonathan on 06/06/2017.
//
//

import UIKit

class ListController: UITableViewController {
    
    var chiefs = [Chief]()
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data
        loadChiefs()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chiefs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ListCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListCell else {
            fatalError("The dequeued cell is not an instance of ListCell.")
        }
        
        // Fetches the appropriate item for the data source layout.
        let chief = chiefs[indexPath.row]
        
        cell.nameLabel.text = chief.name
        cell.chiefPhoto.image = chief.photo
        
        let emptyStar = UIImage(named: "emptyStar")
        let filledStar = UIImage(named: "filledStar")
        
        for i in 0..<5 {
            let star = i >= chief.rating ? emptyStar : filledStar
            cell.stars[i].image = star
        }
        
        cell.tagsLabel.text = chief.tags.joined(separator: ", ")
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Profile" {
            guard let profileController = segue.destination as? ProfileController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedChiefCell = sender as? ListCell else {
                fatalError("Unexpected sender: \(sender ?? "nil")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedChiefCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedChief = chiefs[indexPath.row]
            profileController.chief = selectedChief
            profileController.order = order
        }
    }
    
    // MARK: Private methods
    private func loadChiefs() {
        let photo1 = UIImage(named: "chief-1")
        let photo2 = UIImage(named: "chief-2")
        let photo3 = UIImage(named: "chief-3")
        
        guard let chief1 = Chief(name: "Jean RAYMOND", photo: photo1!, rating: 3, tags: ["Italien", "Traditionnel"], bio: "J’ai toujours adoré cuisiner, surtout les plats italiens. J’ai un grand amour des bons produits et de la simplicité.", meals: ["Pizza napolitaine", "Spaghetti", "Pates à la carbonara", "Choix du vin"]) else {
            fatalError("Unable to instantiate chief1")
        }

        guard let chief2 = Chief(name: "John THOMAS", photo: photo2!, rating: 5, tags: ["Français", "Burger"], bio: "J’ai toujours adoré cuisiner, surtout des bons petits plats. J’ai un grand amour des bons produits et de la simplicité.", meals: ["Hamburger gastronomique", "Frites avec ketchup", "Gratin de chou-fleur", "Baguette"]) else {
            fatalError("Unable to instantiate chief2")
        }

        guard let chief3 = Chief(name: "Anne HAUBOURD", photo: photo3!, rating: 4, tags: ["Libanais", "Chinois"], bio: "J’ai toujours adoré cuisiner, surtout les plats exotiques. J’ai un grand amour des bons produits et de la simplicité.", meals: ["Sandwich falafel", "Riz avec boulettes de viande", "Nems au poisson", "Algue et brindilles"]) else {
            fatalError("Unable to instantiate chief3")
        }

        chiefs += [chief1, chief2, chief3]
    }

}
