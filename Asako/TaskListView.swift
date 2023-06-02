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
    
    var filteredTaskItems: [TaskItem] {
        taskViewModel.filterTaskItems()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredTaskItems.isEmpty {
                    VStack {
                        HStack{
                            Text("No task to date")
                                .font(.title3)
                                .padding()
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("", selection: $taskViewModel.selectedFilter.animation()) {
                                ForEach(TaskFilter.allFilters, id: \.self) {
                                    filter in
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(filteredTaskItems) { taskItem in
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
                        .onDelete { indexSet in
                            taskViewModel.deleteItems(offsets: indexSet, context: viewContext)
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("", selection: $taskViewModel.selectedFilter.animation()) {
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
