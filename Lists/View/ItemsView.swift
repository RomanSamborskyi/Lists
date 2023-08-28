//
//  ItemsView.swift
//  Lists
//
//  Created by Roman Samborskyi on 05.08.2023.
//

import SwiftUI


struct ItemsView: View {
    
    @ObservedObject var vm: ListsViewModel
    let entity: ListEntity
    @State private var title: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var edititngItem: String = ""
    @State private var objID: NSObject?
    @State private var bottonAction: BottomActions = .addButton
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left.square")
                            .font(.system(size: 35,weight: .medium))
                            .foregroundColor(.primary)
                    }).offset(x: UIScreen.main.bounds.width * -0.1)
                    Text(entity.title ?? "NO TITLE")
                        .padding()
                        .font(.system(size: 35,weight: .bold))
                        .frame(maxWidth: 185)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 35,weight: .bold))
                }
                    ScrollView {
                        ScrollViewReader { proxy in
                        ForEach(vm.getItems(for: entity)) { item in
                            HStack(alignment: .center) {
                                Image(systemName: item.isChecked ? "circle.inset.filled" : "circle")
                                    .padding()
                                    .font(.title3)
                                    .foregroundColor(item.isChecked ? Color.gray : Color.primary)
                                VStack(alignment: .leading) {
                                    Text(item.title ?? "NO TITLE")
                                        .font(.title3)
                                        .strikethrough(item.isChecked)
                                        .foregroundColor(item.isChecked ? .gray : .primary)
                                }
                                Spacer()
                            }.padding(5)
                                .background(Color("Apperancy").contrast(0.7))
                                .cornerRadius(10)
                                .contextMenu { contextMenu(item: item)}
                                .id(item)
                                .onTapGesture {
                                    withAnimation(Animation.spring()) {
                                        HapticEngine.instance.getNotification(style: .success)
                                        vm.markAsChecked(item: item)
                                    }
                                }
                        }.padding(.horizontal, 15)
                                .onChange(of: vm.newItemId, perform: { newValue in
                                    withAnimation(Animation.spring()) {
                                        proxy.scrollTo(newValue, anchor: .bottom)
                                    }
                            })
                    }
                    }.padding(.bottom, bottonAction == .addItem ? 80 : 0)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Apperancy"))
                .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded({ swipe in
                        if (swipe.translation.width > 0) {
                            dismiss()
                        }
                    })
                 )
                switch bottonAction {
                case .addItem:
                    AddItem(vm: vm, title: $title, bottomAction: $bottonAction, entity: entity)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .leading))
                        .background(Material.ultraThinMaterial)
                case .editItem:
                    EditMenu(objID: $objID, title: $edititngItem, bottomAction: $bottonAction, vm: vm, entity: entity)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .leading))
                        .background(Material.ultraThinMaterial)
                case .addButton:
                    Button(action: {
                        withAnimation(Animation.spring()) {
                            bottonAction = .addItem
                        }
                    }, label: {
                        Image(systemName: "plus.app")
                            .padding()
                            .foregroundColor(Color.primary)
                            .font(.system(size: 45))
                    })
                }
        }.navigationBarBackButtonHidden(true)
    }
    //Function which return context menu buttons for this view
    func contextMenu(item: ItemEnteity) -> some View {
        return Group {
            Button(role: .destructive, action: {
            vm.deleteItems(item: item)
        }, label: {
            HStack {
                Text("Delete")
                Image(systemName: "trash")
            }
        })
            Button(action: {
                withAnimation(Animation.spring()) {
                    bottonAction = .editItem
                    edititngItem = item.title ?? ""
                    objID = item.objectID
                }
            }, label: {
                HStack {
                    Text("Edit")
                    Image(systemName: "pencil")
                }
            })
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(vm: ListsViewModel(), entity: ListEntity(context: CoreDataManager.instance.context ))
    }
}
//Menu for adding new item in to the specific list
struct AddItem: View {
    let vm: ListsViewModel
    @Binding var title: String
    @Binding var bottomAction: BottomActions
    @FocusState var focus: Bool
    let entity: ListEntity
    var body: some View {
        HStack {
            TextField("Title...", text: $title)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .keyboardType(.default)
                .focused($focus)
                .onSubmit {
                    withAnimation(Animation.spring()) {
                            bottomAction = .addButton
                            focus = false
                    }
                }
            Button(action: {
                withAnimation(Animation.spring()) {
                    if !title.isEmpty {
                            vm.addItem(title: title, list: entity)
                        title = ""
                        focus = true
                    } else {
                        bottomAction = .addButton
                        focus = false
                    }
                }
            }, label: {
                Image(systemName: "checkmark.square.fill")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
            })
        }.onAppear {
            focus = true
        }
    }
}
//Menu for editing and saving edited items
struct EditMenu: View {
    @Binding var objID: NSObject?
    @Binding var title: String
    @Binding var bottomAction: BottomActions
    @ObservedObject var vm: ListsViewModel
    @FocusState var focus: Bool
    let entity: ListEntity
    
    var body: some View {
        HStack {
            TextField("Title...", text: $title)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                .submitLabel(.next)
                .focused($focus)
            Button(action: {
                withAnimation(Animation.spring()) {
                    if !title.isEmpty {
                        vm.editItem(text: title, item: entity, objID: objID ?? NSObject())
                          title = ""
                        bottomAction = .addButton
                        focus = false 
                    } else {
                        bottomAction = .addButton
                        focus = false
                    }
                }
            }, label: {
                Image(systemName: "square.and.pencil")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
            })
        }.onAppear {
            focus = true
        }
    }
}

