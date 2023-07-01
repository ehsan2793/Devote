//
//  ContentView.swift
//  Devote
//
//  Created by Ehsan Rahimi on 7/1/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES

    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }

    // MARK: - FETCHING DATA

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTIONS

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    TextField("New Task", text: $task)
                        .padding()
                        .background(
                            Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)

                    Button(action: {
                        addItem()
                    }, label: {
                        Spacer()
                        Text("save".uppercased())
                        Spacer()
                    })
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(.pink)
                    .cornerRadius(10)
                } //: VSTACK
                .padding()
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Description")
                             //: LIST ITEM
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: LIST ITEM
                        }
                    }
                    .onDelete(perform: deleteItems)
                } //: LIST
            } //: VSTACK
            .navigationTitle("Daily Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            } //: TOOLBAR
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
