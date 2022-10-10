//
//  TasksListViewController.swift
//  RealmApp
//
//  Created by Nazar Lykashik on 12.09.22.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var tasksLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksLists = realm.objects(TasksList.self)
        navigationItem.leftBarButtonItem = editButtonItem        
//        let shopingList = TasksList()
//        shopingList.name = "Shoping List"
//
//
//        // Варианты инициализации свойств Realm
//        // 1 Вариант (длинный)
//
//        let milk = Task()
//        milk.name = "Milk"
//        milk.note = "2L"
//
//        // 2 Вариант (те что не нужны по умолчанию инициализируются днфолтными свойствами и их можно пропустить,
//        // но если нужно свойство после ненужного его все равно придется инициализировать)
//
//        let bread = Task(value: ["Bread", "", Date(), true])
//
//        // 2 Варинат 2 Варианта
//        let moviesList = TasksList(value: ["Movies List", Date(), [["Jonn Wick"], ["Tor", "", Date(), true]]])
//
//        // 3 Вариант через массив (ключи всегда стринг, обьявляем только те свойства которые нужны)
//
//        let aplles = Task(value: ["name": "Aplles", "note": "2Kg"])
//
//        //Добавлнее по одному
//
//        shopingList.tasks.append(milk)
//
//        //Добавление сразу нескольких
//        shopingList.tasks.insert(contentsOf: [bread, aplles], at: 1)
//
//        DispatchQueue.main.async {
//            StorageManager.saveTasksList([shopingList, moviesList])
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBAction func addButton(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    @IBAction func sortList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        }else{
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return tasksLists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        let tasksList = tasksLists[indexPath.row]
        cell.configure(with: tasksList)
        
        return cell
    }
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.alertForAddAndUpdateList(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        
        return [deleteAction, doneAction ,editAction]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTaskList = tasksList
        }
    }
}
extension TasksListViewController{
    private func alertForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil){
        
        var  title = "Nwe List"
        var doneButton = "Save"
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else {return}
            
            if let listName = listName{
                StorageManager.editList(listName, newListName: newList)
                if complition != nil {complition!()}
            } else {
                
                let tasksList = TasksList()
                tasksList.name = newList
                
                StorageManager.saveTasksList(tasksList)
                
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
            }
        }
        let cancelActon = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        
        alert.addTextField{ textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName{
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
    
