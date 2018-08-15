//
//  EditEntryViewController.swift
//  myJournalApp
//
//  Created by Virgil Martinez on 8/14/18.
//  Copyright © 2018 Virgil Alexander Martinez. All rights reserved.
//

import UIKit

class EditEntryViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var entryText: UITextView!
    
    var item: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing if item is passed
        print(item)
        
        configureEntryData(entry: item)
    }
    
    //MARK: - Personal Functions
    func configureEntryData(entry: Item) {
        
        //Setting textfield text to an Item
        if entry.name == "" {
            entryText!.text = "Nothing to update."
        } else {
            entryText.text = entry.name
        }
        //this didn't work...
        //entryText!.text = entry.name ?? "Nothing to update."
    }
    
    //MARK: - System functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Dismisses keyboard if return is pressed
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    //MARK: - ACTIONS
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        
        //Guardlet statement to make sure something is there?
        guard let newEntry = entryText.text else {
            return
        }
        if newEntry == "" {
            //TODO: - Empty state handling
            print("Empty")
        }
        
        //Saving to core data
        item.name = newEntry
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
}
