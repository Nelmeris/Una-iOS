//
//  CourceViewModel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct LessonViewModel {
    
    let title: String
    let stateText: String
    let progress: Float
    let levelColor: UIColor
    let levelTitle: String
    let image: UIImage
    
}

final class LessonViewModelFactory {
    
    func construct(from lessons: [UnaLesson]) -> [LessonViewModel] {
        return lessons.compactMap(self.viewModel)
    }
    
    private func viewModel(from lesson: UnaLesson) -> LessonViewModel {
        let title = lesson.title
        let stateText = "\(0) ИЗ \(lesson.parts?.count ?? 0) УРОКОВ"
        let progress = Float(0) / Float(lesson.parts?.count ?? 0)
        let levelColor = lesson.difficulty.color()
        let levelTitle = lesson.difficulty.rawValue
        let image = UIImage(named: "CourceImage")!
        return LessonViewModel(title: title, stateText: stateText, progress: progress, levelColor: levelColor, levelTitle: levelTitle, image: image)
    }
    
}
