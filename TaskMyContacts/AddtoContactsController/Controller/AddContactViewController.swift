//
//  AddContactViewController.swift
//  TaskMyContacts
//
//  Created by Surendra Ponnapalli on 04/01/20.
//  Copyright © 2019 Surendra Ponnapalli. All rights reserved.
//

import CoreData
import UIKit

class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{
  
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    var imagePicker = UIImagePickerController()

    var imagePicked:Bool = false
    
    var keyBoardHeight:CGFloat = 0
    
        
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var firstNameTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        
        imgView.setCornerRadius(cornerRadius: 63)
        cancelBtn.setCornerRadius(cornerRadius: 12)
        doneBtn.setCornerRadius(cornerRadius: 12)
        descriptionTxtView.addTextfieldBorder(borderWidth: 1.0)
        descriptionTxtView.delegate = self
        descriptionTxtView.setPlaceholder()
        
        firstNameTxtField.layer.borderWidth = 1.0
        
        firstNameTxtField.layer.borderColor = UIColor.lightGray.cgColor
        firstNameTxtField.attributedPlaceholder =
            NSAttributedString(string: "Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

        self.title = "New Todo"
        
    }
    func textViewDidChange(_ textView: UITextView) {
        descriptionTxtView.checkPlaceholder()
    }
    
    @IBAction func cancelBtnActn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func addContactBtnAction(_ sender: Any) {
        if ((firstNameTxtField.text?.isEmpty)!){
            showAlert("Please Enter Title")
            return
        }
        if ((descriptionTxtView.text?.isEmpty)!){
            showAlert("Please Enter Description")
            return
        }
        
        
        if !imagePicked {
            showAlert("Please take the image.")
            return
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        
     let newContact = NSManagedObject(entity: entity!, insertInto: context)
        
        newContact.setValue(firstNameTxtField.text, forKey: "first_Name")
        newContact.setValue(descriptionTxtView.text, forKey: "taskDescr")
        newContact.setValue(false, forKey: "isSelected")
        
        if let img = self.imgView.image {
            let data = img.pngData() as NSData?
            newContact.setValue(data, forKey: "photo")
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Failed saving")
        }

    }
    
    @IBAction func chooseImgBtnAct(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imgView.image = pickedImage
            imagePicked = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func showAlert(_ msg:String) {
        let alert = UIAlertController(title: "Contact", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}



//MARK:- KeyBoard Manager Method
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
}


//MARK:- UITextField Border
extension UIView {
    func addTextfieldBorder(borderWidth: CGFloat) {
        self.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        self.layer.borderWidth = borderWidth
        
        self.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1).cgColor
        
    }
}
//MARK:- Corner Radius
extension UIView {
    func setCornerRadius(cornerRadius:CGFloat) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}

extension UITextView{

    func setPlaceholder() {

        let placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }

}
