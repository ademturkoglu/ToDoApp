//
//  TasksViewState.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 25.05.2021.
//

import Foundation

struct TasksViewState {
    var items: [Task] = []
    var response: TasksResponse? {
        didSet {
            if let tasks = response?.results {
                items = tasks.sorted(by: {  $0.editDate > $1.editDate}).filter({$0.state != .done})
                let doneItems = tasks.filter({$0.state == .done})
                items.append(contentsOf: doneItems)
            }else {
                items = [Task]()
            }
        }
    }
    var filteredItems: [Task] = []
}

extension TasksViewState {
    enum Change {
        case fetchState(fetching: Bool)
        case tasks
        case tasksError(error: Error?)
    }
}

