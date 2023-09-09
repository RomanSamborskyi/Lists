//
//  ListsMainView.swift
//  Lists
//
//  Created by Roman Samborskyi on 05.08.2023.
//

import SwiftUI

struct ListsMainView: View {
    @ObservedObject var vm: ListsViewModel
    @State private var addItemTogle: Bool = false
    @State private var showInfo: Bool = false
    @State private var title: String = ""
    @State private var popoverItem: ListEntity?
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack{
                    Text("LISTS")
                        .padding()
                        .font(.system(size: 40,weight: .bold,design: .rounded))
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundColor(Color.primary)
                        .font(.system(size: 30,weight: .bold,design: .rounded))
                }
                ScrollView {
                    ForEach(vm.savedLists) { list in
                        NavigationLink(destination: { ItemsView(vm: vm, entity: list) }, label: {
                            ZStack(alignment: .topTrailing) {
                                HStack {
                                    Text(list.title ?? "NO TITLE")
                                        .padding()
                                        .font(.title2)
                                        .foregroundColor(Color.primary)
                                    Spacer()
                                }
                                .background(Color("Apperancy").contrast(0.7))
                                .cornerRadius(10)
                                if !((list.items?.count ?? 0) == 0){
                                    Text("\(vm.countItemsInList(list: list) ?? 0)")
                                        .padding(10)
                                        .foregroundColor(Color.primary)
                                        .font(.caption)
                                        .background(Circle().frame(width:35,height: 35)).foregroundColor(Color.red)
                                        .offset(x: -10,y: -5)
                                }
                            }
                        }).contextMenu { contextMenu(item: list) }
                    }.padding(.top, 15)
                    .padding(.horizontal, 15)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Apperancy"))
                .popover(item: $popoverItem, attachmentAnchor: .rect(.bounds), arrowEdge: .bottom, content: { item in popover(list: item) })
            ZStack {
                if addItemTogle {
                    AddList(vm: vm, title: $title, addListTogle: $addItemTogle)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .leading))
                        .background(Material.ultraThinMaterial)
                } else {
                    Button(action: {
                        withAnimation(Animation.spring()) {
                            self.addItemTogle.toggle()
                        }
                    }, label: {
                        Image(systemName: "plus.app")
                            .padding()
                            .foregroundColor(Color.primary)
                            .font(.system(size: 45))
                    })
                }
            }.zIndex(1.5)
        }
    }
    func contextMenu(item: ListEntity) -> some View {
        return Group {
            Button(role: .destructive, action: {
                withAnimation(Animation.spring()) {
                    vm.deleteList(item: item)
                }
            }, label: {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
            Button(action: {
                popoverItem = item
            }, label: {
                HStack {
                    Text("Info")
                    Image(systemName: "info.square")
                }
            })
        }
    }
    func popover(list: ListEntity) -> some View {
        VStack(alignment: .leading) {
            Text("Info")
                .padding()
                .foregroundColor(Color.primary)
                .font(.title2)
            Text("Title of the list: \(list.title ?? "NO TITLE3")")
                .padding()
                .foregroundColor(Color.primary)
                .font(.title3)
            Text("Date of creation: \(vm.date(date: list.date ?? Date()))")
                .padding()
                .foregroundColor(Color.primary)
                .font(.title3)
        }
    }
}

struct ListsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ListsMainView(vm: ListsViewModel())
    }
}

struct AddList: View {
    let vm: ListsViewModel
    @Binding var title: String
    @Binding var addListTogle: Bool
    var body: some View {
        HStack {
            TextField("Title...", text: $title)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .submitLabel(.next)
            Button(action: {
                if !title.isEmpty {
                    vm.addList(title: title)
                    title = ""
                    addListTogle.toggle()
                } else {
                    addListTogle.toggle()
                }
            }, label: {
                Image(systemName: "checkmark.square.fill")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
            })
        }
    }
}

