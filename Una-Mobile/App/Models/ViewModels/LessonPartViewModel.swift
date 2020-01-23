//
//  LessonPartViewModel.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

struct LessonPartViewModel: Updateble {
    
    let id: Int
    let title: String
    let isCompleted: Bool
    
    static func == (lhs: LessonPartViewModel, rhs: LessonPartViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.isCompleted == rhs.isCompleted
    }
    
    func isUpdated(rhs: LessonPartViewModel) -> Bool {
        return self != rhs && self.id == rhs.id
    }
    
}

final class LessonPartViewModelFactory {
    
    func construct(from parts: [LessonPart]) -> [LessonPartViewModel] {
        return parts.compactMap(self.viewModel)
    }
    
    private func viewModel(from part: LessonPart) -> LessonPartViewModel {
        let id = part.id!.intValue
        let title = part.title!
        let isCompleted = false
        return LessonPartViewModel(id: id, title: title, isCompleted: isCompleted)
    }
    
}
