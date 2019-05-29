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
    
    override func viewDidLoad() {
        self.navigationItem.title = "АКТИВНЫЕ КУРСЫ"
        self.tableView.separatorColor = UIColor.clear;
        guard let accessToken = Keychain.load("access_token") else { return }
        YLService.shared.getCources(accessToken: accessToken) { (response) in
            DispatchQueue.main.async {
                guard let value = response.value else { return }
                
                self.cources = value
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cource = self.cources[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableId) as! StudyTableViewCell
        
        let color = cource.level.color()
        cell.levelView.backgroundColor = color
        cell.titleLabel.text = cource.title
        cell.stateLabel.text = "\(cource.learnedLessonsCount) ИЗ \(cource.lessonsCount) УРОКОВ"
        cell.progressView.progress = Float(cource.learnedLessonsCount) / Float(cource.lessonsCount)
        cell.levelLabel.text = cource.level.rawValue
        cell.courceImage.image = UIImage(named: "CourceImage")
        cell.levelView.reloadInputViews()
        
        return cell
    }
    
}
