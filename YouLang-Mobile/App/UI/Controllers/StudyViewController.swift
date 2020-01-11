//
//  StudyViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class StudyViewController: UITableViewController, StudyView {
    
    // MARK: - Properties
    
    private var viewModels: [LessonViewModel] = []
    private var lessons: [UnaLesson] = []
    private let reusableId = "StudyTableViewCellReusable"
    private var presenter: StudyViewPresenter!
    
    // MARK: - Outlets
    
    @IBOutlet var router: StudyRouter!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = StudyPresenter(view: self)
        configureTableView()
        configureNavigationBar()
        presenter.showCources()
    }
    
    private func configureTableView() {
        view.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Уроки".uppercased()
    }
    
    func setCources(lessons: [UnaLesson], viewModels: [LessonViewModel]) {
        self.lessons = lessons
        self.viewModels = viewModels
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - TableViewDataSource
extension StudyViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as! StudyTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        router.toLesson { (controller) in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            controller.lesson = self.lessons[indexPath.row]
        }
        self.hidesBottomBarWhenPushed = false
    }
    
}
