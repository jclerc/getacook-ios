//
//  ItemTableViewController.swift
//  GetACook
//
//  Created by Jonathan on 03/06/2017.
//
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {
    
    // MARK: Properties
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load data
        if let items = loadItems() {
            self.items += items
        } else {
            loadSampleItems()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        
        // Fetches the appropriate item for the data source layout.
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        cell.ratingControl.rating = item.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Save items
            saveItems()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
            guard let itemDetailViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? ItemTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nil")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nil")")
            
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let source = sender.source as? ItemViewController, let item = source.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new item
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save items
            saveItems()
        }
    }

    // MARK: Private methods
    private func loadSampleItems() {
        let photo1 = UIImage(named: "item1")
        let photo2 = UIImage(named: "item2")
        let photo3 = UIImage(named: "item3")
        
        guard let item1 = Item(name: "Voiture", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate item1")
        }
        
        guard let item2 = Item(name: "Métro", photo: photo2, rating: 2) else {
            fatalError("Unable to instantiate item2")
        }
        
        guard let item3 = Item(name: "Avion", photo: photo3, rating: 5) else {
            fatalError("Unable to instantiate item3")
        }
        
        items += [item1, item2, item3]
    }
    
    private func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save items...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
}
