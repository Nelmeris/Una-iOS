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
    
    static func == (lhs: LessonPartViewModel, rhs: LessonPartViewModel) -> Bool {
        return lhs.title == rhs.title
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
        return LessonPartViewModel(id: id, title: title)
    }
    
}
