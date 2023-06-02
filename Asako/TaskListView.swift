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
    
    var body: some View {
        NavigationView {
            VStack {
                let filteredTaskItems = taskViewModel.filterTaskItems()
                
                if filteredTaskItems.isEmpty {
                    HStack {
                        Text("No task to date")
                            .font(.title3)
                            .padding()
                        Spacer()
                    }
                    
                    let taskList = List {
                        ForEach(filteredTaskItems) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(taskItem: taskItem, viewContext: viewContext)
                                Spacer()
                            }
                        }
                        .onDelete { indexSet in
                            taskViewModel.deleteItems(offsets: indexSet, context: viewContext)
                        }
                    }
                    .listStyle(.plain)
                    
                    let toolbarItem = ToolbarItem(placement: .confirmationAction) {
                        Picker("", selection: $taskViewModel.selectedFilter.animation()) {
                            ForEach(TaskFilter.allFilters, id: \.self) {
                                filter in
                                Text(filter.rawValue)
                            }
                        }
                    }
                    
                    taskList
                        .toolbar {
                            toolbarItem
                        }
                } else {
                    let taskList = List {
                        ForEach(filteredTaskItems) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(taskItem: taskItem, viewContext: viewContext)
                                Spacer()
                            }
                        }
                        .onDelete { indexSet in
                            taskViewModel.deleteItems(offsets: indexSet, context: viewContext)
                        }
                        
                    }
                        
                    .listStyle(.plain)
                    
                    let toolbarItem = ToolbarItem(placement: .confirmationAction) {
                        Picker("", selection: $taskViewModel.selectedFilter.animation()) {
                            ForEach(TaskFilter.allFilters, id: \.self) {
                                filter in
                                Text(filter.rawValue)
                            }
                        }
                    }
                    
                    taskList
                        .toolbar {
                            toolbarItem
                        }
                }
                
                NavigationLink {
                    TaskEditView(passedTaskItem: nil, initialDate: Date())
                        .environmentObject(taskViewModel)
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
}
