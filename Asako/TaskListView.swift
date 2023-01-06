//
//  TaskListView.swift
//  Asako
//
//  Created by Dina Andrianarijaona on 04/01/2023.
//

import SwiftUI
import CoreData

/// \
struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @State var selectedFilter = TaskFilter.All
    //    @State var arrayCount: Int = 0
    
    

    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(filteredTaskItems()) { taskItem in
                        ZStack {
                            NavigationLink(destination:
                                            TaskEditView(passedTaskItem: taskItem, initialDate: Date()).environmentObject(dateHolder)
                            ) {
                                EmptyView()
                            }
                            
                            TaskRow(passedTaskItem: taskItem)
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
                            }                        }
                    }
                }
                //                .listStyle(.grouped)
                
                NavigationLink {
                    TaskEditView(passedTaskItem: nil, initialDate: Date())
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                        Text("New Task")
                            .bold()
                            .foregroundColor(.purple)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading)
                    
                }
                
                
            }
            
        }
        
        .accentColor(.purple)
        
        
    }
    
    private func filteredTaskItems() -> [TaskItem] {
        if selectedFilter == TaskFilter.Completed {
            return dateHolder.taskItems.filter {$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.NonCompleted {
            return dateHolder.taskItems.filter {!$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.OverDue {
            return dateHolder.taskItems.filter {$0.isOverdue()}
        }
        
        return dateHolder.taskItems
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTaskItems()[$0] }.forEach(viewContext.delete)
            
            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


