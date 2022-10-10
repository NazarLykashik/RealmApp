//
//  Extension + Cell.swift
//  RealmApp
//
//  Created by Nazar Lykashik on 28.09.22.
//

import UIKit
extension UITableViewCell{
    func configure(with tasksList: TasksList){
        let curentTasks = tasksList.tasks.filter("isComplete = false")
        let compleatedTask = tasksList.tasks.filter("isComplete = true")
        
        textLabel?.text = tasksList.name
        
        if !curentTasks.isEmpty{
            detailTextLabel?.text = "\(curentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .gray
        }else if !compleatedTask.isEmpty {
            detailTextLabel?.text = "✔︎"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        }else{
            detailTextLabel?.text = "0"
        }
    }
}
