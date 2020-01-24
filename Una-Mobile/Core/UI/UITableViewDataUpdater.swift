//
//  UITableViewDataUpdater.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

extension UITableView {
    
    func updateData<T: Updateble>(data: [T], newData: [T],
                                  insertAnimation: UITableView.RowAnimation = .automatic,
                                  deleteAnimation: UITableView.RowAnimation = .automatic,
                                  reloadAnimation: UITableView.RowAnimation = .automatic) {
        let updateInforms = data.updateInforms(from: newData)
        var deleteIndexPaths = [IndexPath]()
        var updateIndexPaths = [IndexPath]()
        var insertIndexPaths = [IndexPath]()
        var moveIndexPaths = [(IndexPath, IndexPath)]()
        for updateInfo in updateInforms {
            let indexPath = IndexPath(row: updateInfo.index, section: 0)
            switch updateInfo.type {
            case .added:
                insertIndexPaths.append(indexPath)
            case .updated:
                updateIndexPaths.append(indexPath)
            case .deleted:
                deleteIndexPaths.append(indexPath)
            case .moved:
                let oldIndexPath = IndexPath(row: updateInfo.oldIndex!, section: 0)
                moveIndexPaths.append((indexPath, oldIndexPath))
            }
        }
        self.reloadRows(at: updateIndexPaths, with: reloadAnimation)
        self.deleteRows(at: deleteIndexPaths, with: deleteAnimation)
        self.insertRows(at: insertIndexPaths, with: insertAnimation)
        for indexPaths in moveIndexPaths {
            self.moveRow(at: indexPaths.0, to: indexPaths.1)
        }
    }
    
}
