//
//  TaskCreateViewState.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 28.05.2021.
//

import Foundation

struct TaskCreateViewState {
    var task = Task()

}

extension TaskCreateViewState {
    enum Change {
        case saved
        case dueDateAdded(date: Date?)
        case tagAdded(tag: String)
    }
}
