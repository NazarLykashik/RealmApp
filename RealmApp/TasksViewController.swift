//
//  TasksViewController.swift
//  RealmApp
//
//  Created by Nazar Lykashik on 12.09.22.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var currentTaskList: TasksList!
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    private var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTaskList.name
        filtringTasks()
    }
    
    @IBAction func editButton(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    @IBAction func addButton(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            StorageManager.deleteTask(task)
            self.filtringTasks()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.alertForAddAndUpdateList(task)
            self.filtringTasks()
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
            StorageManager.makeDone(task)
            self.filtringTasks()
        }
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        return [deleteAction, doneAction, editAction]
    }

    private func filtringTasks(){
        currentTasks = currentTaskList.tasks.filter("isComplete = false")
        completedTasks = currentTaskList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
  

}
extension TasksViewController{
    private func alertForAddAndUpdateList(_ taskName: Task? = nil){
        var title = "New Task"
        var doneButton = "Save"
        if taskName != nil{
            title = "Edit Task"
            doneButton = "Update"
        }
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = taskTextField.text, !newTask.isEmpty else {return}
            
            if let taskName = taskName{
                if let newNote = noteTextField.text, !newNote.isEmpty{
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                }else{
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
                self.filtringTasks()
            }else{
                let task = Task()
                task.name = newTask
                
                if let note = noteTextField.text, !note.isEmpty{
                    task.note = note
                }
                StorageManager.saveTask(self.currentTaskList, task: task)
                self.filtringTasks()
            }
        }
        let cancelActon = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        
        alert.addTextField{ textField in
            taskTextField = textField
            taskTextField.placeholder = "New Task"
            
            if let taskName = taskName{
                taskTextField.text = taskName.name
            }
        }
        alert.addTextField{ textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
            
            if let taskName = taskName{
                noteTextField.text = taskName.note
            }
        }
        present(alert, animated: true)
    }
}
