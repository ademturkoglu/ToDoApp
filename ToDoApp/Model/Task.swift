//
//  Task.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 25.05.2021.
//

import Foundation

struct TasksResponse: Codable {
    var results: [Task]?
}

struct Task: Codable{
    var id = UUID()
    var title: String?
    var description: String?
    var tags: [String]?
    var dueDate: Date?
    var editDate: Date!
    var state: State?
}

enum State: String,Codable {
    case todo
    case done
}


