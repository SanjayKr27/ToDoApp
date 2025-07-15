//
//  ContentView.swift
//  ToDoApp
//
//  Created by SANJAY on 15/07/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntity.timestamp, ascending: false)],
        animation: .default
    ) private var tasks: FetchedResults<TaskEntity>

    @StateObject private var taskVM = TaskViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter a new task", text: $taskVM.newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        taskVM.addTask()
                    }) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }

                List {
                    ForEach(tasks) { task in
                        VStack(alignment: .leading) {
                            Text(task.title ?? "")
                                .font(.headline)
                            Text(task.timestamp ?? Date(), style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { i in
                            taskVM.deleteTask(tasks[i])
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
