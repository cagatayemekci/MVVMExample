//
//  ToDoModel.swift
//  MVVMExample
//
//  Created by Çağatay Emekci on 27.01.2019.
//  Copyright © 2019 Çağatay Emekci. All rights reserved.
//

import Foundation

struct ToDoModel: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
