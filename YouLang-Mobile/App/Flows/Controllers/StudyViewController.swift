//
//  StudyViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import Keychain

class StudyViewController: UITableViewController {
    
    var cources: [YLCourceModel] = []
    let reusableId = "StudyTableViewCellReusable"
    @IBOutlet var router: StudyRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        
        guard let accessToken = Keychain.load("access_token") else { return }
        YLService.shared.getCources(accessToken: accessToken) { (response) in
            guard let value = response.value else { return }
            
            self.cources = value
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorColor = UIColor.clear
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "АКТИВНЫЕ КУРСЫ"
    }
    
}

// MARK: - Table view data source
extension StudyViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cource = self.cources[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath) as? StudyTableViewCell else {
            return UITableViewCell()
        }
        
        let color = cource.level.color()
        cell.levelView.backgroundColor = color
        cell.titleLabel.text = cource.title
        cell.stateLabel.text = "\(cource.learnedLessonsCount) ИЗ \(cource.lessonsCount) УРОКОВ"
        cell.progressView.progress = Float(cource.learnedLessonsCount) / Float(cource.lessonsCount)
        cell.levelLabel.text = cource.level.rawValue
        cell.courceImage.image = UIImage(named: "CourceImage")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        router.toLesson { (controller) in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            controller.cource = self.cources[indexPath.row]
        }
        self.hidesBottomBarWhenPushed = false
    }
    
}
