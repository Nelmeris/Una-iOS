//
//  CourceViewModel.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct LessonViewModel: Updateble {
    
    let id: Int
    let title: String
    let underTitle: String
    let stateText: String
    let levelColor: UIColor
    let levelTitle: String
    
    static func == (lhs: LessonViewModel, rhs: LessonViewModel) -> Bool {
        let f = lhs.title == rhs.title &&
            lhs.stateText == rhs.stateText &&
            lhs.levelColor.toHexString() == rhs.levelColor.toHexString() &&
            lhs.levelTitle == rhs.levelTitle
        return f
    }
    
    func isUpdated(rhs: LessonViewModel) -> Bool {
        return self != rhs && self.id == rhs.id
    }
    
}

final class LessonViewModelFactory {
    
    func construct(from lessons: [Lesson]) -> [LessonViewModel] {
        return lessons.compactMap(self.viewModel)
    }
    
    private func viewModel(from lesson: Lesson) -> LessonViewModel {
        let id = Int(lesson.id)
        let title = lesson.title!
        let underTitle = lesson.underTitle!
        let stateText = "\(0) ИЗ \(lesson.parts?.count ?? 0) ШАГОВ"
        let difficulty = DifficultyLevel(rawValue: lesson.difficulty!)
        let levelColor = difficulty!.color()
        let levelTitle = difficulty!.rawValue
        return LessonViewModel(id: id, title: title, underTitle: underTitle, stateText: stateText, levelColor: levelColor, levelTitle: levelTitle)
    }
    
}
