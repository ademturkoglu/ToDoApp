//
//  TasksViewModel.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 26.05.2021.
//

import Foundation

class TasksViewModel {
    var state = TasksViewState()
    var changeHandler: ((TasksViewState.Change) -> Void)?
    var isFilteringHandler: (() -> (Bool))?
    
    func filterContent(forText text: String) {
        state.filteredItems = state.items.filter({ (model) -> Bool in
            (model.title?.lowercased().contains(text.lowercased())) ?? false
           || (model.description?.lowercased().contains(text.lowercased())) ?? false
                || (model.tags?.contains(text.lowercased())) ?? false
        })
        
        self.changeHandler?(.tasks)
    }
    
    func getTasks() {
        state.response = UserDefaultsHelper.tasksResponse
        self.changeHandler?(.tasks)
    }
    
    func createAHundredTask(){
        for i in 1...100 {
            let task = Task(title: "TEST TITLE \(i)", description: "TEST DESCRIPTION \(i)",tags: ["test tag \(i)"], editDate: Date(), state: .todo)
            UserDefaultsHelper.setOrUpdateTask(value: task)
        }
        getTasks()
    }
    
    func numberOfItems() -> Int {
        associatedArray.count
    }

    func itemAtIndex(row: Int) -> Task? {
        associatedArray[row]
    }
    
    func deleteTask(row: Int) {
        UserDefaultsHelper.deleteTask(value: associatedArray[row])
        getTasks()
    }
    
    func deleteAllTasks() {
        UserDefaultsHelper.deleteAllTasks()
        getTasks()
    }
    
    func updateTaskToDone(row: Int){
        var task = associatedArray[row]
        task.state = .done
        UserDefaultsHelper.setOrUpdateTask(value: task)
        getTasks()
    }
    
}

extension TasksViewModel {
    
  var associatedArray: [Task] {
    isFiltering ? state.filteredItems : state.items
  }
    
  var isFiltering: Bool {
    isFilteringHandler?() ?? false
  }
  
}
