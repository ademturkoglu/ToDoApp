//
//  TaskCreateViewModel.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 28.05.2021.
//

import Foundation


class TaskCreateViewModel {
    var state = TaskCreateViewState()
    var changeHandler: ((TaskCreateViewState.Change) -> Void)?
    
    
    func addTag(tag: String){
        if (state.task.tags) == nil {
            state.task.tags = [String]()
        }
        state.task.tags?.append(tag.lowercased())
        self.changeHandler?(.tagAdded(tag: tag.lowercased()))
    }
    
    func removeTag(tag: String){
        if let index = state.task.tags?.firstIndex(of: tag){
            state.task.tags?.remove(at: index)
        }
    }
    
    func setTask(task: Task) {
        state.task = task
    }
    
    func saveTask() {
        state.task.editDate = Date()
        state.task.state = .todo
        UserDefaultsHelper.setOrUpdateTask(value: state.task)
        self.changeHandler?(.saved)
    }
    
    func getTask() -> Task {
        return state.task
    }
    
    func setDueDate(date: Date?) {
        state.task.dueDate = date
        self.changeHandler?(.dueDateAdded(date: date))
    }
    
    func setTitle(title: String) {
        state.task.title = title
    }
    
    func setDescription(description: String?) {
        state.task.description = description
    }
    
}
