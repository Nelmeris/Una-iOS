//
//  StudyViewPresenter.swift
//  YouLang-Mobile
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
    
    required init(view: StudyView) {
        self.view = view
    }
    
    func showCources() {
        loadData { lessons in
            let viewModels = self.viewModelFactory.construct(from: lessons)
            self.view.setCources(lessons: lessons, viewModels: viewModels)
        }
    }
    
    private func loadData(completion: @escaping ([UnaLesson]) -> ()) {
        do {
            try UnaService.shared.getLessons { lessons in
                completion(lessons)
            }
        } catch {
            print(error)
        }
    }
    
}
