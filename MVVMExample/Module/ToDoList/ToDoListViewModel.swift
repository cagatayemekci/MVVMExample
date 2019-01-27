//
//  ToDoListViewModel.swift
//  MVVMExample
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import Foundation

class ToDoListViewModel {
    
    private var todoList :[ToDoModel] = [ToDoModel]()
    let apiService: APIServiceProtocol
    
    var numberOfCells: Int {
        return todoList.count
    }
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    private var cellViewModels: [ToDoListCellModel] = [ToDoListCellModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ToDoListCellModel {
        return cellViewModels[indexPath.row]
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchToDoList { [weak self] (success, todolist, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedToDo(todoList:todolist)
            }
        }
    }
    
    private func processFetchedToDo( todoList: [ToDoModel] ) {
        self.todoList = todoList // Cache
        var vms = [ToDoListCellModel]()
        for toDo in todoList {
            vms.append( createCellViewModel(toDo: toDo) )
        }
        self.cellViewModels = vms
    }
    
    func createCellViewModel( toDo: ToDoModel ) -> ToDoListCellModel {
        return ToDoListCellModel(id:toDo.id, title: toDo.title, completed: toDo.completed)
    }
}

