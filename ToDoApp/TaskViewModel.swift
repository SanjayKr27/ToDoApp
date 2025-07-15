//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by SANJAY on 15/07/25.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    let context = PersistenceController.shared.container.viewContext

    @Published var newTaskTitle: String = ""

    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = TaskEntity(context: context)
        newTask.title = newTaskTitle
        newTask.timestamp = Date()
        save()
        newTaskTitle = ""
    }

    func deleteTask(_ task: TaskEntity) {
        context.delete(task)
        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("CoreData Save Error: \(error.localizedDescription)")
        }
    }
}
