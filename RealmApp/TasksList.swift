//
//  TasksList.swift
//  RealmApp
//
//  Created by Nazar Lykashik on 14.09.22.
//

import RealmSwift
class TasksList: Object{
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
