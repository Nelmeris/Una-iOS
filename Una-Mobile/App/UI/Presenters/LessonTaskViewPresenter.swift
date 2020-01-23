//
//  LessonTaskViewPresenter.swift
//  Una-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

protocol LessonTaskView: class {
    func setTask(_ task: LessonTaskViewModel, isFirst: Bool, isLast: Bool)
    func setResult(message: String)
}

protocol LessonTaskViewPresenter {
    init(view: LessonTaskView, lessonPart: LessonPart)
    func showLesson()
    func showNextTask()
    func showPrevTask()
    func showResult()
    func tapOnKeywordProcessing(keyword: inout LessonTaskSubstring)
}


class LessonTaskPresenter : LessonTaskViewPresenter {
    
    unowned let view: LessonTaskView
    
    private var lessonTasks: [LessonTask] = []
    private let lessonPart: LessonPart
    private var viewModels: [LessonTaskViewModel] = []
    private let viewModelFactory = LessonTaskViewModelFactory()
    private var currentTask = 0
    
    required init(view: LessonTaskView, lessonPart: LessonPart) {
        self.view = view
        self.lessonPart = lessonPart
    }
    
    private func loadTasks() {
        LessonsDataManager.default.getLessonTasks(for: lessonPart.id!.intValue) { result in
            switch result {
            case .success(let tasks):
                self.lessonTasks = tasks
                self.updateView()
                break
            case .failure(let error):
                print(error)
                // TODO
            }
        }
    }
    
    func showLesson() {
        loadTasks()
        guard let tasks = lessonPart.tasks?.allObjects as! [LessonTask]? else { return }
        self.lessonTasks = tasks
    }
    
    private func updateView() {
        self.viewModels = self.viewModelFactory.construct(from: self.lessonTasks)
        self.showTask()
    }
    
    func showNextTask() {
        guard currentTask <= lessonTasks.count else { return }
        if (currentTask == lessonTasks.count - 1) {
            showResult()
            return
        }
        currentTask += 1
        showTask()
    }
    
    func showPrevTask() {
        guard currentTask > 0 else { return }
        currentTask -= 1
        showTask()
    }
    
    func showTask() {
        guard viewModels.count != 0 else { return }
        let isFirst = currentTask == 0
        let isLast = currentTask == viewModels.count - 1
        let viewModel = viewModels[currentTask]
        view.setTask(viewModel, isFirst: isFirst, isLast: isLast)
    }
    
    func showResult() {
        let result = getResult()
        view.setResult(message: "Верно \(result.goodCount) из \(result.count)")
    }
    
    // Проверка общего результата
    private func getResult() -> (goodCount: Int, count: Int) {
        var goodCount = 0
        let count = viewModels.count
        viewModels.forEach { model in
            if checkTask(model) {
                goodCount += 1
            }
        }
        return (goodCount, count)
    }
    
    // Проверка задания
    func checkTask(_ viewModel: LessonTaskViewModel) -> Bool {
        let attributedText = viewModel.attributedText
        for substring in viewModel.substrings { // Все ключевые слова
            let range = NSRange(location: substring.position, length: substring.changedValue.count)
            let attributes = attributedText.attributes(at: substring.position, longestEffectiveRange: nil, in: range)
            
            for attribute in attributes {
                if let substring = attribute.value as? LessonTaskSubstring,
                    !checkKeyword(substring, attributes) {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Проверка ключевого слова
    private func checkKeyword(_ keyword: LessonTaskSubstring, _ attributes: [NSAttributedString.Key: Any]) -> Bool {
        switch keyword.type {
        case .input:
            return keyword.isCorrectAnswer(value: keyword.changedValue)
        case .find:
            guard let attr = getAttributeFrom(attributes, key: .backgroundColor) as? UIColor else { return false }
            let unselColor = UIColor(named: "UnselectedColor")!
            return unselColor != attr && keyword.answers.first!.isCorrect ||
                unselColor == attr && !keyword.answers.first!.isCorrect
        }
    }
    
    // Получение определенного атрибута
    private func getAttributeFrom(_ attributes: [NSAttributedString.Key: Any], key: NSAttributedString.Key) -> Any? {
        for attr in attributes {
            if attr.key == key {
                return attr.value
            }
        }
        return nil
    }
    
    // Обработка нажатия на ключевое слово
    func tapOnKeywordProcessing(keyword: inout LessonTaskSubstring) {
        viewModels[currentTask].tapOnKeywordProcessing(keyword: &keyword)
        showTask()
    }
    
}
