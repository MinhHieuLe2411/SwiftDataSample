//
//  Note.swift
//  HieuSwiftData
//
//  Created by Lê Minh Hiếu on 5/8/25.
//

import Foundation
import SwiftData

@Model
class Note {
    var uuid: UUID
    var title: String
    var content: String
    var createdAt: Date

    init(title: String, content: String, createdAt: Date = .now) {
        self.uuid = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
