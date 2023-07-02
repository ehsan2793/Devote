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
    @State private var showNewTaskItem: Bool = false

    // MARK: - FETCHING DATA

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTIONS

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
        NavigationStack {
            ZStack {
                // MARK: - MAIN VIEW

                VStack {
                    // MARK: - HEADER
                    HStack(spacing: 10) {
                        // TITLE
                        // EDIT BUTTON
                        // APPERANCE BUTTON
                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    
                    Spacer(minLength: 40)
                    // MARK: - NEW TASK BUTTON

                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0, y: 4)
                    )
                    Spacer(minLength: 20)

                    // MARK: - TASKS

                    ScrollView {
//                        VStack(alignment: .leading) {
                        ForEach(Array(items.enumerated()),id: \.element.id ) { (index, item) in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Created at \(item.timestamp!, formatter: itemFormatter)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    deleteItems(offsets: [index])
                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.pink)
                                })
                            }

                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)

                            Divider()
                                .padding(.horizontal, 50)
                        } //: LIST ITEM
//                        .onDelete(perform: deleteItems)
                        .background(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    } //: SCROLL
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK

                // MARK: - NEW TASK ITEM

                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTastItemView(isShowing: $showNewTaskItem)
                }
            } //: ZSTACK
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationTitle("Daily Task")
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//            } //: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
