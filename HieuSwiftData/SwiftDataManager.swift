//
//  SwiftDataManager.swift
//  HieuSwiftData
//
//  Created by Lê Minh Hiếu on 5/8/25.
//

// Data/SwiftDataManager.swift
import Foundation
import SwiftData

@MainActor
class SwiftDataManager {
    static let shared = SwiftDataManager()

    let container: ModelContainer

    var context: ModelContext {
        container.mainContext
    }

    private init() {
        do {
            let schema = Schema([Note.self])
            let config = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("❌ Lỗi khi khởi tạo SwiftData: \(error)")
        }
    }

    func addNote(title: String, content: String) {
        let note = Note(title: title, content: content)
        context.insert(note)
    }

    func addSampleNotes(count: Int) {
        for i in 1...count {
            let note = Note(title: "Ghi chú \(i)", content: "Nội dung mẫu số \(i)")
            context.insert(note)
        }
    }

    func getAllNotes() -> [Note] {
        let descriptor = FetchDescriptor<Note>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func getNote(by uuid: UUID) -> Note? {
        let descriptor = FetchDescriptor<Note>(
            predicate: #Predicate { $0.uuid == uuid }
        )
        return try? context.fetch(descriptor).first
    }

    func delete(note: Note) {
        context.delete(note)
    }
    
    func update(note: Note, newTitle: String, newContent: String) {
        note.title = newTitle
        note.content = newContent
        // Không cần gọi save() – SwiftData tự xử lý
    }
}
