//
//  TaskListView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selectedFilter = TaskFilter.All
    
    var body: some View {
        NavigationView {
            VStack {
                if taskViewModel.filteredTaskItems() == [] {
                    HStack {
                        Text("No task to date")
                            .font(.title3)
                            .padding()
                        Spacer()
                    }
                    List {
                        ForEach(taskViewModel.filteredTaskItems()) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(passedTaskItem: taskItem)
                                Spacer()
                            }
                        }
                        .onDelete(perform: taskViewModel.deleteItems)
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
                        ForEach(taskViewModel.filteredTaskItems()) { taskItem in
                            ZStack {
                                NavigationLink(destination:
                                                TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(taskViewModel)
                                ) {
                                    EmptyView()
                                }
                                
                                TaskRow(passedTaskItem: taskItem)
                                Spacer()
                            }
                        }
                        .onDelete(perform: taskViewModel.deleteItems)
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
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


