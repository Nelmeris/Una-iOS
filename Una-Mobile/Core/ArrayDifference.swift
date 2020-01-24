//
//  ArrayDifference.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

protocol Updateble: Hashable {
    func isUpdated(rhs: Self) -> Bool
}

extension Array where Element: Updateble {
    
    enum DataUpdateType {
        case deleted, added, updated, moved
    }
    
    struct DataUpdateInfo {
        let type: DataUpdateType
        let index: Int
        let oldIndex: Int?
    }
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
    func updateInforms(from other: [Element]) -> [DataUpdateInfo] {
        let different = self.difference(from: other)
        var updateInforms = [DataUpdateInfo]()
        for diffElement in different {
            let indexInSelf = self.firstIndex { $0 == diffElement || $0.isUpdated(rhs: diffElement) }
            let indexInOther = other.firstIndex { $0 == diffElement || $0.isUpdated(rhs: diffElement) }
            if let indexInSelf = indexInSelf,
                let indexInOther = indexInOther,
                self[indexInSelf].isUpdated(rhs: other[indexInOther]) {
                if indexInSelf == indexInOther {
                    updateInforms.append(DataUpdateInfo(type: .updated, index: indexInOther, oldIndex: nil))
                } else {
                    updateInforms.append(DataUpdateInfo(type: .moved, index: indexInOther, oldIndex: indexInSelf))
                }
            } else if let indexInSelf = indexInSelf {
                updateInforms.append(DataUpdateInfo(type: .deleted, index: indexInSelf, oldIndex: nil))
            } else if let indexInOther = indexInOther {
                updateInforms.append(DataUpdateInfo(type: .added, index: indexInOther, oldIndex: nil))
            }
        }
        return updateInforms
    }
    
}
