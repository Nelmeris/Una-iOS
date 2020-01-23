//
//  LessonPartViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 11.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol LessonPartView: class {
    func setParts(_ parts: [LessonPart], viewModels: [LessonPartViewModel])
}

protocol LessonPartViewPresenter {
    init(view: LessonPartView, lesson: Lesson)
    func showParts()
}


class LessonPartPresenter : LessonPartViewPresenter {
    
    unowned let view: LessonPartView
    private let viewModelFactory = LessonPartViewModelFactory()
    private let lesson: Lesson
    
    required init(view: LessonPartView, lesson: Lesson) {
        self.view = view
        self.lesson = lesson
    }
    
    func showParts() {
        loadParts()
        guard let parts = lesson.parts?.allObjects as! [LessonPart]? else { return }
        let viewModels = self.viewModelFactory.construct(from: parts)
        self.view.setParts(parts, viewModels: viewModels)
    }
    
    private func loadParts() {
        LessonsDataManager.default.get(for: Int(lesson.id)) { result in
            switch result {
            case .success(let parts):
                let viewModels = self.viewModelFactory.construct(from: parts)
                self.view.setParts(parts, viewModels: viewModels)
                break
            case .failure(let error):
                print(error)
                // TODO
            }
        }
    }
    
}
