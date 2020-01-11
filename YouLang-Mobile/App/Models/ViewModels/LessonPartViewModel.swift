//
//  LessonPartViewModel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

struct LessonPartViewModel {
    
    let title: String
    
}

final class LessonPartViewModelFactory {
    
    func construct(from parts: [UnaLessonPart]) -> [LessonPartViewModel] {
        return parts.compactMap(self.viewModel)
    }
    
    private func viewModel(from part: UnaLessonPart) -> LessonPartViewModel {
        let title = part.title
        return LessonPartViewModel(title: title)
    }
    
}
