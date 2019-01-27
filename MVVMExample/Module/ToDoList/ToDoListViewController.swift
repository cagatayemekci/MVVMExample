//
//  ToDoListViewController.swift
//  MVVMExample
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    lazy var toDoListViewModel: ToDoListViewModel = {
        return ToDoListViewModel()
    }()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.rowHeight = UITableView.automaticDimension
        toDoListTableView.estimatedRowHeight = 80
        initVM()
    }
    
    fileprivate func initVM(){
        
        toDoListViewModel.initFetch()
        
        toDoListViewModel.reloadTableViewClosure = {[weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.toDoListTableView.reloadData()
            }
        }
        
        toDoListViewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                let isLoading = self.toDoListViewModel.isLoading
                if isLoading {
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.toDoListTableView.alpha = 0.0
                    })
                }else {
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.toDoListTableView.alpha = 1.0
                    })
                }
            }
        }
        
        toDoListViewModel.showAlertClosure = {[weak self] () in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let message = self.toDoListViewModel.alertMessage {
                    self.showAlert( message )
                }
            }
        }
    }
    
    fileprivate func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCellIdentifier", for: indexPath) as? ToDoTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = toDoListViewModel.getCellViewModel( at: indexPath )
        cell.toDoListCellModel = cellVM
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
