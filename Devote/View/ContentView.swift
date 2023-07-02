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

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        Spacer()
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 16)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white, lineWidth: 2)
                            )
                        // APPERANCE BUTTON
                        Button(action: {
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })
                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)

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
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            HStack {
                                ListRowItemView(item: item)
                                Spacer()
                                Button(action: {
                                    if item.completion {
                                        deleteItems(offsets: [index])
                                    }

                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(item.completion ? .pink : .gray)
                                })
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)

                            .padding(.horizontal, 20)

                            Divider()
                                .padding(.horizontal, 50)
                        } //: LIST ITEM
                        //                        .onDelete(perform: deleteItems)
                        .background(
                            isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
                        )
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
                    BlankView(
                        backgroundColor: isDarkMode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
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
