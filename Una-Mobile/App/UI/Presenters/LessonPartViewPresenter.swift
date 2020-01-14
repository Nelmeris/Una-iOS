//
//  LessonPartViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol LessonPartView: class {
    func setParts(_ parts: [UnaLessonPart], viewModels: [LessonPartViewModel])
}

protocol LessonPartViewPresenter {
    init(view: LessonPartView, lesson: UnaLesson)
    func showParts()
}


class LessonPartPresenter : LessonPartViewPresenter {
    
    unowned let view: LessonPartView
    private let viewModelFactory = LessonPartViewModelFactory()
    private let lesson: UnaLesson
    
    required init(view: LessonPartView, lesson: UnaLesson) {
        self.view = view
        self.lesson = lesson
    }
    
    func showParts() {
        loadData { parts in
            let viewModels = self.viewModelFactory.construct(from: parts)
            self.view.setParts(parts, viewModels: viewModels)
        }
    }
    
    private func loadData(completion: @escaping ([UnaLessonPart]) -> ()) {
        do {
            try UnaDBService.shared.getLessonParts(for: lesson.id) { parts in
                completion(parts)
            }
        } catch {
            print(error)
        }
    }
    
}
