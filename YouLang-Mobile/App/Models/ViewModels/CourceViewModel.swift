//
//  CourceViewModel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct CourceViewModel {
    
    let title: String
    let stateText: String
    let progress: Float
    let levelColor: UIColor
    let levelTitle: String
    let image: UIImage
    
}

final class CourceViewModelFactory {
    
    func construct(from cources: [YLCourceModel]) -> [CourceViewModel] {
        return cources.compactMap(self.viewModel)
    }
    
    private func viewModel(from cource: YLCourceModel) -> CourceViewModel {
        let title = cource.title
        let stateText = "\(cource.learnedLessonsCount) ИЗ \(cource.lessonsCount) УРОКОВ"
        let progress = Float(cource.learnedLessonsCount) / Float(cource.lessonsCount)
        let levelColor = cource.level.color()
        let levelTitle = cource.level.rawValue
        let image = UIImage(named: "CourceImage")!
        return CourceViewModel(title: title, stateText: stateText, progress: progress, levelColor: levelColor, levelTitle: levelTitle, image: image)
    }
    
}
