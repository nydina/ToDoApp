//
//  TaskListView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selectedFilter = TaskFilter.All
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredTaskItems() == [] {
                    HStack {
                        Text("No task to date")
                            .font(.title3)
                            .padding()
                        Spacer()
                    }
                    List {
                        ForEach(filteredTaskItems()) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(taskItem: taskItem)
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("", selection: $selectedFilter.animation()) {
                                ForEach(TaskFilter.allFilters, id: \.self) {
                                    filter in
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(filteredTaskItems()) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(taskItem: taskItem)
                                Spacer()
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("", selection: $selectedFilter.animation()) {
                                ForEach(TaskFilter.allFilters, id: \.self) {
                                    filter in
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    }
                }
                
                NavigationLink {
                    TaskEditView(passedTaskItem: nil, initialDate: Date())
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                        Text("New Task")
                            .bold()
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading)
                    
                }
                .accessibilityLabel("Add new task")
                
            }
            .navigationTitle("To Do List")
        }
        
        .tint(.accentColor)
    }
    
    private func filteredTaskItems() -> [TaskItem] {
        if selectedFilter == TaskFilter.Completed {
            return taskViewModel.taskItems.filter {$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.NonCompleted {
            return taskViewModel.taskItems.filter {!$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.OverDue {
            return taskViewModel.taskItems.filter {$0.isOverdue()}
        }
        
        return taskViewModel.taskItems
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTaskItems()[$0] }.forEach(viewContext.delete)
            
            taskViewModel.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


