//
//  StudyViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Keychain

protocol StudyView: class {
    func setCources(lessons: [UnaLesson], viewModels: [LessonViewModel])
}

protocol StudyViewPresenter {
    init(view: StudyView)
    func showCources()
}


class StudyPresenter : StudyViewPresenter {
    
    unowned let view: StudyView
    private let viewModelFactory = LessonViewModelFactory()
    private var lessons: [UnaLesson] = []
    
    required init(view: StudyView) {
        self.view = view
    }
    
    func showCources() {
        loadData { lessons in
            self.lessons = lessons
            for (i, _) in self.lessons.enumerated() {
                self.loadParts(for: self.lessons[i]) { lesson in
                    self.lessons[i] = lesson
                    self.updateView()
                }
            }
            self.updateView()
        }
    }
    
    private func updateView() {
        let viewModels = self.viewModelFactory.construct(from: lessons)
        self.view.setCources(lessons: lessons, viewModels: viewModels)
    }
    
    private func loadData(completion: @escaping ([UnaLesson]) -> ()) {
        do {
            try UnaDBService.shared.getLessons { lessons in
                completion(lessons)
            }
        } catch {
            print(error)
        }
    }
    
    private func loadParts(for lesson: UnaLesson, completion: @escaping (UnaLesson) -> ()) {
        var lesson = lesson
        do {
            try UnaDBService.shared.getLessonParts(for: lesson.id) { parts in
                lesson.parts = parts
                completion(lesson)
            }
        } catch {
            print(error)
        }
    }
    
}
