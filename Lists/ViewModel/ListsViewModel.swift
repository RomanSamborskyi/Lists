
 // ListsViewModel.swift
 // Lists

 // Created by Roman Samborskyi on 05.08.2023.


import Foundation
import CoreData


class ListsViewModel: ObservableObject {
    
    static let instanse = ListsViewModel()
    let coreData = CoreDataManager.instance
    @Published var savedLists: [ListEntity] = []
    @Published var newItemId: ItemEnteity?
    
    init() {
        getLists()
    }
    
    func getLists() {
        let request = NSFetchRequest<ListEntity>(entityName: coreData.listEntityName)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ListEntity.title, ascending: true)]
        do {
            savedLists = try coreData.context.fetch(request)
        } catch let error {
            print("ERROR OF FETCHING LISTS: \(error)")
        }
    }
    func getItems(for item: ListEntity) -> [ItemEnteity] {
        let requset = NSFetchRequest<ItemEnteity>(entityName: coreData.itemEntityNAme)
        requset.predicate = NSPredicate(format: "lists == %@",item)
        requset.sortDescriptors = [NSSortDescriptor(keyPath: \ItemEnteity.isChecked, ascending: true)]
        do {
            return try coreData.context.fetch(requset)
        } catch let error {
            print("ERROR OF FETCHING ITEMS: \(error)")
            return []
        }
    }
 
    func addList(title: String) {
        let newList = ListEntity(context: coreData.context)
        newList.title = title
        newList.date = Date()
        save()
    }
    func addItem(title: String, list: ListEntity) {
        let newItem = ItemEnteity(context: coreData.context)
        newItem.title = title
        newItem.isChecked = false
        newItem.lists = list
        newItemId = newItem
        save()
    }
    func deleteList(item: ListEntity) {
        guard let index = savedLists.firstIndex(of: item) else { return }
        let deleteItem = savedLists[index]
        coreData.context.delete(deleteItem)
        save()
    }
    func deleteItems(item: ItemEnteity) {
        if let array = item.lists?.items?.allObjects as? [ItemEnteity] {
            guard let index = array.firstIndex(of: item) else { return }
            let deleted = array[index]
            coreData.context.delete(deleted)
            save()
        }
    }
    func markAsChecked(item: ItemEnteity) {
        if let array = item.lists?.items?.allObjects as? [ItemEnteity] {
            guard let index = array.firstIndex(of: item) else { return }
            let item = array[index]
            item.isChecked = !item.isChecked
            save()
            getLists()
        }
    }
    func editItem(text: String, item: ListEntity, objID: NSObject) {
        guard let indexInLists = savedLists.firstIndex(of: item) else { return }
        let itemInList = savedLists[indexInLists]
            if let itemArray = itemInList.items?.allObjects as? [ItemEnteity] {
                guard let index = itemArray.first(where: {$0.objectID == objID}) else { return }
                index.title = text
                save()
        }
    }
    func save() {
        coreData.save()
        getLists()
    }
    
    func date(date: Date ) -> String {
        let curentDate = Date()
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .short
        return formater.string(from: date)
    }
    func countOfAllItems() -> NSNumber {
        return savedLists.count as? NSNumber ?? 0
    }
}
