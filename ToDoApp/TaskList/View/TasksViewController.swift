//
//  ViewController.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 25.05.2021.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var fab: FloatingActionButton! {
        didSet {
            fab.imageView.image = UIImage(named: "plus")
            fab.setTitle("Add To-do item")
        }
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var viewModel = TasksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchController()
        configureNavigationBar()
        setupViewModel()
        setupViewModelHandlers()
        viewModel.getTasks()
        configureNotificationCenter()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fab.isHidden = false
    }

    @IBAction func addActionTapped(_ sender: Any) {
        routeToCreate()
    }
    

    
}
//Setup Handlers and Search bar
extension TasksViewController {
    
    func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveData(_:)), name: NSNotification.Name(rawValue: "ReceiveData"), object: nil)
    }
    
    func configureNavigationBar() {
        navigationItem.title = "To Do App"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add(Hundred)",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(createTasksForTest))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete all",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(deleteAll))
    }
    
    private func setupViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            self.viewModelStateChanged(change: change)
        }
    }
    
    func setupViewModelHandlers() {
        viewModel.isFilteringHandler = {[weak self] in
            guard let self = self else {return false}
            return self.searchController.isActive && !self.isSearchBarEmpty
        }
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        searchController.searchBar.tintColor = UIColor.black
        definesPresentationContext = true
    }
    
    @objc func createTasksForTest() {
        viewModel.createAHundredTask()
    }
    
    @objc func deleteAll() {
        viewModel.deleteAllTasks()
    }
    
    @objc func onReceiveData(_ notification:Notification) {
        viewModel.getTasks()
    }
}

extension TasksViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.filterContent(forText: searchController.searchBar.text!)
  }
}


extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let model = viewModel.itemAtIndex(row: indexPath.row){
            routeToDetail(model: model)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {(action, sourceView, completionHandler) in
            self.viewModel.deleteTask(row: indexPath.row)
            completionHandler(true)
        }
            deleteAction.image = #imageLiteral(resourceName: "delete")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.4901960784, blue: 0.4823529412, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) {(action, sourceView, completionHandler) in
            self.viewModel.updateTaskToDone(row: indexPath.row)

            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "doneSwipe")
        doneAction.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)
        
        guard let model = viewModel.itemAtIndex(row: indexPath.row) else { return nil}
        
        return model.state != .done ?  UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as! ToDoTableViewCell
        cell.configure(with: viewModel.itemAtIndex(row: indexPath.row))
        
        return cell
    }
}

extension TasksViewController {
    var isSearchBarEmpty: Bool {
     return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func routeToDetail(model: Task) {
        let storyboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as? TaskDetailViewController {
            destinationVC.model = model
            self.show(destinationVC, sender: nil)
        }
    }
    
    func routeToCreate() {
        let storyboard = UIStoryboard(name: "TaskCreateOrEdit", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "TaskCreateViewController") as? TaskCreateViewController {
            self.show(destinationVC, sender: nil)
        }
    }

    private func viewModelStateChanged(change: TasksViewState.Change){
        switch change {
        case let .fetchState(_): break
              //  fetching ? showIndicator() : hideIndicator()
        case .tasks:
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case let .tasksError(error: error):
            print(error ?? "error")
        }
    }
}


