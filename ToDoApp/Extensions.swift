//
//  DateExt.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 28.05.2021.
//

import Foundation
import UIKit

extension Date {
    
    enum Format : String {
        case full = "HH:mm E, d MMM y"
    }
    
    
    func toString (format : Date.Format) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format.rawValue
        return dateformatter.string(from: self)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
