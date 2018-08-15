//
//  JournalTableViewController.swift
//  myJournalApp
//
//  Created by Virgil Martinez on 8/10/18.
//  Copyright © 2018 Virgil Alexander Martinez. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController, UISearchBarDelegate {

    //MARK: - Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Item] = []
    var selectedIndex: Int!
    var filteredData: [Item] = []
    
    //MARK: - Personal Functions
    func fetchData() {
        do {
            //Gathers items from Core Data
            items = try context.fetch(Item.fetchRequest())
            
            //Setting our filtered array to all the items for now
            filteredData = items
            
            /*
             troubleshooting
             print("\nDATA:\n \(items)")
             print("COUNT: \(items.count)")
           */
            
            //I'm not sure why this is necessary but refreshed table basically
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
    }
    
    //Makes a uisearchbar and puts it at the top of the tableview!!!! veddy koo
    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //if search bar has nothing in it than the filtered data is the same as all the data
        if searchText.isEmpty {
            filteredData = items
        } else {
            //else filter the data
            filteredData = items.filter{ ($0.name?.lowercased().contains(searchText.lowercased()))! }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - System functions
    
    //Makes sure table is updated before it is presented
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table properties
        self.tableView.estimatedRowHeight = 44
        
        //Makes each cell expand to fit text properly
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        createSearchBar()

    }
    
    //Passing Data to Edit View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateVC" {
            //Set item here
            let updateVC = segue.destination as! EditEntryViewController
            updateVC.item = filteredData.reversed()[selectedIndex!]
        }
    }
}

//MARK: - TABLE EXTENSION

extension JournalTableViewController {
    
    //Displaying the table with the items from the array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let date = filteredData.reversed()[indexPath.row].date
        let time = filteredData.reversed()[indexPath.row].time
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = filteredData.reversed()[indexPath.row].name
        
        if let date = date, let time = time {
            let timeStamp = "Added on \(date) at \(time)"
            cell.detailTextLabel?.text = timeStamp
        }
        
        return cell
    }
    
    //Amount of cells/rows set to array length (duh)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    //lmao...don't set this to zero apparently
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Allowing for swipe to delete...aka super swanky UX
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete"){
            (action, indexPath) in
        
            let item = self.filteredData[indexPath.row]
            
            //Deleting from coredata
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            //Deleteing from array and table
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        //Allow users to share..tutorial didn't have this functionality but if you're not lazy you can have it :O
        let share = UITableViewRowAction(style: .normal, title: "Share") {
            (action, indexPath) in
            print("Share")
        }
        
        //returning table row actions
        return [delete, share]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storing selected index for use with prepare for segue
        selectedIndex = indexPath.row
        
        //gets rid of the highlight
        tableView.deselectRow(at: indexPath, animated: true)
        
        //performs segue with prepare for segue 
        performSegue(withIdentifier: "UpdateVC", sender: self)
    }
}
