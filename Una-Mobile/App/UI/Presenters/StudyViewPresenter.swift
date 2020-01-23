//
//  StudyViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

protocol StudyView: class {
    func setCources(lessons: [Lesson], viewModels: [LessonViewModel])
}

protocol StudyViewPresenter {
    init(view: StudyView)
    func showCources()
}


class StudyPresenter : StudyViewPresenter {
    
    unowned let view: StudyView
    private let viewModelFactory = LessonViewModelFactory()
    private var lessons: [Lesson] = []
    
    required init(view: StudyView) {
        self.view = view
    }
    
    func showCources() {
        LessonsDataManager.default.getLessons { result in
            switch result {
            case .success(let lessons):
                self.lessons = lessons
                self.updateView()
                for (index, lesson) in lessons.enumerated() {
                    LessonsDataManager.default.getLessonParts(for: Int(lesson.id)) { result in
                        switch result {
                        case .success(let parts):
                            self.lessons[index].parts = NSSet(array: parts)
                            self.updateView()
                            break
                        case .failure(let error):
                            print(error)
                            // TODO
                        }
                    }
                }
            case .failure(let error):
                print(error)
                // TODO
            }
        }
    }
    
    private func updateView() {
        let viewModels = self.viewModelFactory.construct(from: lessons)
        self.view.setCources(lessons: lessons, viewModels: viewModels)
    }
    
}
