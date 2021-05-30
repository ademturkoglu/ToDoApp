//
//  DateViewController.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 28.05.2021.
//

import UIKit

protocol DateViewControllerDelegate: class {
    func didCancel(_ sender: UIButton)
    func provide(date: Date)
}

final class DateViewController: UIViewController {

    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DateViewControllerDelegate?
    
    var onViewDidLoad: ()->() = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minimumDate = Date()
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        delegate?.didCancel(sender)
    }
    
    @IBAction func onDone(_ sender: UIButton) {
        delegate?.provide(date: datePicker.date)
    }
    
}


