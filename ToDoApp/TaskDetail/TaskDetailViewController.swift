//
//  TaskDetailViewController.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 26.05.2021.
//

import UIKit
import TagListView

class TaskDetailViewController: UIViewController{

    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = model.title
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.text = model.description
        }
    }
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            if let date = model.dueDate {
                dateLabel.text = date.toString(format: .full)
            }else{
                dateLabel.text = "-"
            }
        }
    }
    @IBOutlet weak var tagListView: TagListView!{
        didSet{
            guard let tags = model.tags else {
                return
            }
            for tag in tags {
                tagListView.addTag(tag)
            }
           
        }
    }
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            statusLabel.text = model.state?.rawValue.uppercased()
        }
    }
    
    
    
    var model: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(editButtonItemTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc  func editButtonItemTapped() {
        routeToCreate(model: model)
    }
    
    func routeToCreate(model: Task) {
        let storyboard = UIStoryboard(name: "TaskCreateOrEdit", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "TaskCreateViewController") as? TaskCreateViewController {
            destinationVC.viewModel.setTask(task: model)
            self.show(destinationVC, sender: nil)
        }
    }

}


