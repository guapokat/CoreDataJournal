//
//  AddItemViewController.swift
//  myJournalApp
//
//  Created by Virgil Martinez on 8/10/18.
//  Copyright © 2018 Virgil Alexander Martinez. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var itemEntryTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Text view behavior
        itemEntryTextview.delegate = self
        itemEntryTextview.text = "Type anything here..."
        itemEntryTextview.textColor = UIColor.lightGray
    
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Dismisses keyboard if return is pressed
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //sets text color to black vs gray
    func textViewDidBeginEditing(_ itemEntryTextView: UITextView) {
        if itemEntryTextview.textColor == UIColor.lightGray {
            //print("Got Here")
            itemEntryTextview.text = nil
            itemEntryTextview.textColor = UIColor.black
        }
    }
    
    //sets text color to light gray if empty
    func textViewDidEndEditing(_ itemEntryTextView: UITextView) {
        if itemEntryTextview.text.isEmpty {
            itemEntryTextview.text = "Type anything here..."
            itemEntryTextview.textColor = UIColor.lightGray
        }
    }
    
    

    // MARK: - ACTIONS
    @IBAction func addButton(_ sender: UIButton) {
        guard let enteredText = itemEntryTextview?.text else { return }
        
        //if its empty present alert
        if enteredText.isEmpty || itemEntryTextview?.text == "Type anything here..." {
            let alert = UIAlertController(title: "Please Type Something", message: "Your entry was left blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in })
            self.present(alert, animated: true, completion: nil)
        }else {
            guard let entryText = itemEntryTextview?.text else {
                return
            }
            //formatting date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            let currentDate = formatter.string(from: date)
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            let currentTime = timeFormatter.string(from: date)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newEntry = Item(context: context)
            newEntry.name = entryText
            newEntry.date = currentDate
            newEntry.time = currentTime
            //SAVE
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
