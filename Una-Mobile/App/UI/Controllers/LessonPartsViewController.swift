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
        tableView.delegate = self
        tableView.dataSource = self
        presenter = LessonPartPresenter(view: self, lesson: lesson)
        presenter.showParts()
        self.title = lesson.title.uppercased()
    }
    
}

extension LessonPartsViewController: LessonPartView {
    
    func setParts(_ parts: [UnaLessonPart], viewModels: [LessonPartViewModel]) {
        self.parts = parts
        self.viewModels = viewModels
        self.tableView.reloadData()
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
    
}
