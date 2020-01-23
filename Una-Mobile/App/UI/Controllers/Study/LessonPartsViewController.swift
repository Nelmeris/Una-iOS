//
//  LessonPartsViewController.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class LessonPartsViewController: UIViewController {
    
    // MARK: - Properties
    var lesson: Lesson!
    private var parts: [LessonPart] = []
    private var viewModels: [LessonPartViewModel] = []
    private var selectedCellIndex = 0
    private var presenter: LessonPartPresenter!
    private let reusableId = "LessonPartTableViewCellReusable"
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var router: LessonRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        
        presenter = LessonPartPresenter(view: self, lesson: lesson)
        presenter.showParts()
    }
    
    private func configureNavBar() {
        self.title = lesson.title!.uppercased()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
    }
    
    @IBAction func openTask(_ sender: Any) {
        guard viewModels.count != 0 else { return }
        router.toTask { (controller) in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            controller.lessonPart = self.parts[self.selectedCellIndex]
        }
    }
    
}

extension LessonPartsViewController: LessonPartView {
    
    func setParts(_ parts: [LessonPart], viewModels: [LessonPartViewModel]) {
        self.parts = parts
        for (index, model) in viewModels.enumerated() {
            if !model.isCompleted {
                self.selectedCellIndex = index
                break
            }
        }
        self.updateTable(with: viewModels)
    }
    
}

extension LessonPartsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as! LessonPartTableViewCell
        cell.isSelected = selectedCellIndex == indexPath.row
        cell.configure(with: model, isFirst: indexPath.row == 0, isLast: indexPath.row == viewModels.count - 1, isActive: indexPath.row == 0 && !viewModels[indexPath.row].isCompleted || indexPath.row != 0 && viewModels[indexPath.row - 1].isCompleted != viewModels[indexPath.row].isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModels[indexPath.row].isCompleted || indexPath.row != 0 && viewModels[indexPath.row - 1].isCompleted else { return }
        let oldSelectedIndex = selectedCellIndex
        selectedCellIndex = indexPath.row
        tableView.reloadRows(at: [IndexPath(row: oldSelectedIndex, section: 0)], with: .none)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func updateTable(with models: [LessonPartViewModel]) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.updateData(data: self.viewModels, newData: models)
            self.viewModels = models
            self.tableView.endUpdates()
            if self.viewModels.count != 0 {
                self.tableView.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
