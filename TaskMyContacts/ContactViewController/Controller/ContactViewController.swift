//
//  ViewController.swift
//  TaskMyContacts
//
//  Created by Surendra Ponnapalli on 04/01/20.
//  Copyright © 2019 Surendra Ponnapalli. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController {
    
    var searchActive : Bool = false
    
    var filtered:[ContactModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactsArray: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchContacts()
    }

    @IBAction func addBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let contactVc = storyBoard.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
        self.navigationController?.pushViewController(contactVc, animated: true)
    }
    
    
    func fetchContacts(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            contactsArray = []
            for data in result as! [NSManagedObject] {
                
                var model = ContactModel()
                model.firstName = data.value(forKey: "first_Name") as! String
                model.photo = data.value(forKey: "photo") as! Data
                model.description = data.value(forKey: "taskDescr") as! String
                model.isSelected = data.value(forKey: "isSelected") as! Bool
                self.contactsArray.append(model)
            }
            let allValues = self.contactsArray
            self.contactsArray = []
            var selectedList:[ContactModel] = []
            for model in allValues {
                if !model.isSelected {
                    self.contactsArray.append(model)
                }else{
                    selectedList.append(model)
                }
            }
            self.contactsArray.append(contentsOf: selectedList)
            self.tableView.reloadData()
        } catch {
            print("Failed")
        }
    }
    
    func updateExstingRecord(_ userName:String, isSelected:Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "first_Name = %@", userName)
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if fetchResults?.count != 0{
                let managedObject = fetchResults?[0]
                managedObject?.setValue(isSelected, forKey: "isSelected")
                try context.save()
            }
        } catch  {
            print("Failed saving")
        }
    }
}

// MARK:- SEARCH DELEGATES
extension ContactViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = contactsArray.filter {$0.firstName.lowercased().contains(searchText.lowercased()) }
        searchActive = true;
        self.tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
}
// MARK:- TABLEVIEW DELEGATES
extension ContactViewController:UITableViewDelegate,UITableViewDataSource{
    func checBtnActn() {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        var model = ContactModel()
        
        if(searchActive){
            model = filtered[indexPath.row]
        }else{
            model = contactsArray[indexPath.row]
        }
        
        cell.contactName.text = model.firstName
        cell.contactImage.image = UIImage(data: model.photo)
        cell.descripLbl.text = model.description
        cell.contactImage.setCornerRadius(cornerRadius: 20)
        if model.isSelected {
            cell.checkBtn.setImage(UIImage(named: "selected"), for: .normal)
        }else{
            cell.checkBtn.setImage(UIImage(named: "unSelected"), for: .normal)
        }
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(checkBoxClicked(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    @objc func checkBoxClicked(_ sender: UIButton) {
        var contactModel = self.contactsArray[sender.tag]
        contactModel.isSelected = !contactModel.isSelected
        self.contactsArray.remove(at: sender.tag)
        self.contactsArray.append(contactModel)
        
        let allValues = self.contactsArray
        self.contactsArray = []
        var selectedList:[ContactModel] = []
        for model in allValues {
            if !model.isSelected {
                self.contactsArray.append(model)
            }else{
                selectedList.append(model)
            }
        }
        self.contactsArray.append(contentsOf: selectedList)
        updateExstingRecord(contactModel.firstName, isSelected: contactModel.isSelected)
        self.tableView.reloadData()
    }
    
}



