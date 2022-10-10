//
//  Task.swift
//  RealmApp
//
//  Created by Nazar Lykashik on 14.09.22.
//

import RealmSwift
class Task: Object{
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
