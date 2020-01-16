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
    var lesson: UnaLesson!
    private var parts: [UnaLessonPart] = []
    private var viewModels: [LessonPartViewModel] = []
    private var presenter: LessonPartPresenter!
    
    // MARK: - Outlets
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
        self.title = lesson.title.uppercased()
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
    }
    
}

extension LessonPartsViewController: LessonPartView {
    
    func setParts(_ parts: [UnaLessonPart], viewModels: [LessonPartViewModel]) {
        self.parts = parts
        self.updateTable(with: viewModels)
    }
    
}

extension LessonPartsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        router.toTask { (controller) in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            controller.lessonPart = self.parts[indexPath.row]
        }
        self.hidesBottomBarWhenPushed = false
    }
    
    private func updateTable(with models: [LessonPartViewModel]) {
        self.viewModels = models
        DispatchQueue.main.async {
            self.tableView.updateData(data: self.viewModels, newData: models)
        }
    }
    
}
