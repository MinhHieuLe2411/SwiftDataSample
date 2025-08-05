//
//  ViewController.swift
//  HieuSwiftData
//
//  Created by Lê Minh Hiếu on 5/8/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var notes: [Note] = []

    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white

        setupTableView()

        Task {
            await loadInitialNotes()
        }
    }

    func setupTableView() {
        tableView.register(cellType: SampleCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func loadInitialNotes() async {
        // Nếu chưa có dữ liệu, thêm dữ liệu mẫu
        //        let current = SwiftDataManager.shared.getAllNotes()
        //        if current.isEmpty {
        //            SwiftDataManager.shared.addSampleNotes(count: 10)
        //        }

        // Reload UI
        notes = SwiftDataManager.shared.getAllNotes()
        tableView.reloadData()
    }

    @IBAction func tapAddNote(_ sender: Any) {
        i += 1
        SwiftDataManager.shared.addNote(
            title: "Ghi chú \(i)",
            content: "Nội dung mẫu số \(i)"
        )

        Task {
            await loadInitialNotes()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(
            with: SampleCell.self,
            for: indexPath
        )
        let note = notes[indexPath.row]
        cell.lbl.text =
            "\(note.title) - \(note.createdAt.formatted(date: .numeric, time: .shortened))"
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let note = notes[indexPath.row]

        let alert = UIAlertController(
            title: "Sửa Ghi Chú",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { $0.text = note.title }
        alert.addTextField { $0.text = note.content }

        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
                guard let self = self else { return }
                let newTitle = alert.textFields?[0].text ?? ""
                let newContent = alert.textFields?[1].text ?? ""

                SwiftDataManager.shared.update(
                    note: note,
                    newTitle: newTitle,
                    newContent: newContent
                )
                self.notes = SwiftDataManager.shared.getAllNotes()
                tableView.reloadData()
            }
        )

        present(alert, animated: true)
    }

    //    func tableView(_ tableView: UITableView,
    //                   commit editingStyle: UITableViewCell.EditingStyle,
    //                   forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let note = notes[indexPath.row]
    //            SwiftDataManager.shared.delete(note: note)
    //            notes.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    )
        -> UISwipeActionsConfiguration?
    {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Xoá"
        ) { _, _, completion in
            let note = self.notes[indexPath.row]
            SwiftDataManager.shared.delete(note: note)
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        let editAction = UIContextualAction(
            style: .normal,
            title: "Sửa"
        ) { _, _, completion in
            // Code mở màn sửa
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

}
