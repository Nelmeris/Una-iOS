//
//  LessonViewPresenter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

protocol LessonView: class {
    func setTask(_ task: LessonViewModel, isFirst: Bool, isLast: Bool)
    func setResult(message: String)
}

protocol LessonViewPresenter {
    init(view: LessonView)
    func showLesson()
    func showNextTask()
    func showPrevTask()
    func showResult()
    func tapOnKeywordProcessing(keyword: inout LessonTaskSubstring)
}


class LessonPresenter : LessonViewPresenter {
    
    unowned let view: LessonView
    
    private var lessonTasks: [LessonTask] = []
    private var viewModels: [LessonViewModel] = []
    private let viewModelFactory = LessonViewModelFactory()
    private var currentTask = 0
    
    required init(view: LessonView) {
        self.view = view
        lessonTasks = tasks
    }
    
    func showLesson() {
        self.viewModels = viewModelFactory.construct(from: lessonTasks)
        showTask()
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
        let count = tasks.count
        viewModels.forEach { model in
            if checkTask(model) {
                goodCount += 1
            }
        }
        return (goodCount, count)
    }
    
    // Проверка задания
    func checkTask(_ viewModel: LessonViewModel) -> Bool {
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

let tasks = [
    LessonTask(helpMessage: "Выберите правильное окончание", text: "Мы долго любовались этой прекрасной рекой.",
               keySubstrings: [
                LessonTaskSubstring(value: "ой", position: 39, type: .input, answers: [
                    LessonTaskAnswer(value: "ой", isCorrect: true),
                    LessonTaskAnswer(value: "ый", isCorrect: false),
                    LessonTaskAnswer(value: "ому", isCorrect: false),
                    LessonTaskAnswer(value: "ему", isCorrect: false),
                    LessonTaskAnswer(value: "его", isCorrect: false)
                ])
        ]),
    LessonTask(helpMessage: "Найдите существительные в творительном падеже",
               text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
               keySubstrings: [
                LessonTaskSubstring(value: "спортом", position: 72, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                ]),
                LessonTaskSubstring(value: "футболом", position: 90, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                ]),
                LessonTaskSubstring(value: "командой", position: 169, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                ]),
                LessonTaskSubstring(value: "футболом", position: 215, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                ])
        ]),
    LessonTask(helpMessage: "Найдите существительные в творительном падеже",
               text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
               keySubstrings: [
                LessonTaskSubstring(value: "спортом", position: 72, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                    ]),
                LessonTaskSubstring(value: "футболом", position: 90, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                    ]),
                LessonTaskSubstring(value: "командой", position: 169, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                    ]),
                LessonTaskSubstring(value: "футболом", position: 215, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                    ])
        ]),
    LessonTask(helpMessage: "Найдите существительные в творительном падеже",
               text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
               keySubstrings: [
                LessonTaskSubstring(value: "спортом", position: 72, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                    ]),
                LessonTaskSubstring(value: "футболом", position: 90, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                    ]),
                LessonTaskSubstring(value: "командой", position: 169, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: false)
                    ]),
                LessonTaskSubstring(value: "футболом", position: 215, type: .find, answers: [
                    LessonTaskAnswer(value: "", isCorrect: true)
                    ])
        ])
]
