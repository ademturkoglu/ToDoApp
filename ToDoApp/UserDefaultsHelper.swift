//
//  UserDefaultsManager.swift
//  ToDoApp
//
//  Created by Adem Türkoğlu on 26.05.2021.
//

import Foundation
import UIKit

final class UserDefaultsHelper {
    static var tasksResponse : TasksResponse? {
         get {
            return _get(valueForKey: .tasks) as? TasksResponse
        }
        
    }
    
    private static var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static func setOrUpdateTask(value: Task) {
        var tasks: [Task]
        if let items = tasksResponse?.results {
            tasks = items.filter{$0.id != value.id}
            tasks.append(value)
        }else {
            tasks = [value]
        }
        appDelegate?.scheduleNotification(task: value)
        save(tasks: tasks)
    }
    
    private static func save(tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(TasksResponse(results: tasks)) {
            UserDefaults.standard.set(encoded, forKey: Defaults.tasks.rawValue)
        }
    }
    
    static func deleteTask(value: Task) {
        if let items = tasksResponse?.results {
            let tasks = items.filter{$0.id != value.id}
            save(tasks: tasks)
            appDelegate?.removeNotificationRequest(task: value)
        }
    }

    static func deleteAllTasks() {
        UserDefaults.standard.removeObject(forKey: Defaults.tasks.rawValue)
        appDelegate?.removeAllNotificationRequests()
    }

    private static func _get(valueForKey key: Defaults)-> Any? {
        if let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data,
            let response = try? JSONDecoder().decode(TasksResponse.self, from: data) {
            
            return response

            }
        return UserDefaults.standard.value(forKey: key.rawValue)
    }

}

private enum Defaults : String {
    case tasks = "tasks"
}
