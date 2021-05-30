//
//  TaskCreateViewController.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 27.05.2021.
//

import UIKit
import TagListView
import FittedSheets

class TaskCreateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dismissSheet: () ->() = {}
    var viewModel = TaskCreateViewModel()
    var model: Task!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = viewModel.getTask()
        tagListView.delegate = self
        dateTextField.delegate = self
        setupViewModel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(save))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        setupFields()
        
       
    }
    
    private func setupViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            self.viewModelStateChanged(change: change)
        }
    }
    
    func setupFields() {
            titleTextField.text = model.title
            descriptionTextField.text = model.description
            dateTextField.text = model.dueDate?.toString(format: .full)
            if let tags = model.tags {
                tagListView.addTags(tags)
            }
    }
    
    @IBAction func addTagTapped(_ sender: Any) {
        if let tag = tagTextField.text?.trimmingCharacters(in: .whitespaces), tag != ""{
            viewModel.addTag(tag: tag)
        }
    }
    
    @objc func save() {
        if let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), title != ""{
            viewModel.setTitle(title: title)
            viewModel.setDescription(description: descriptionTextField.text)
            viewModel.saveTask()
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 30
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

}

extension TaskCreateViewController {
    
    private func viewModelStateChanged(change: TaskCreateViewState.Change){
        switch change {
        case .saved:
            NotificationCenter.default.post(name: Notification.Name("ReceiveData"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        case .tagAdded(let tag):
            tagListView.addTag(tag)
            tagTextField.text = ""
        case .dueDateAdded(let date):
            dateTextField.text = date?.toString(format: .full)
        }
    }
}

extension TaskCreateViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dateVC = DateViewController()
        dateVC.delegate = self
         let sheetController = SheetViewController(controller: dateVC, sizes: [.fixed(280)], options: .default)
        self.dismissSheet = {
            sheetController.dismiss(animated: true, completion: nil)
        }
         self.present(sheetController, animated: true, completion: nil)
        textField.endEditing(true)
    
    }
}

extension TaskCreateViewController: DateViewControllerDelegate {
    func didCancel(_ sender: UIButton) {
        dismissSheet()
        dateTextField.text = nil
        viewModel.setDueDate(date: nil)
    }
    
    func provide(date: Date) {
        viewModel.setDueDate(date: date)
        dismissSheet()
    }
    
    
    
}

extension TaskCreateViewController: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
        viewModel.removeTag(tag: title)
     
    }
}
