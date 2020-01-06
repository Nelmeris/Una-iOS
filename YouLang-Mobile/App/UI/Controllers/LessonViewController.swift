//
//  LessonViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController, UIGestureRecognizerDelegate, AlertDelegate {
    
    // MARK: - Properties
    
    var tasks = [
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
    
    var attributedTasks: [NSMutableAttributedString] = []
    var cource: YLCourceModel!
    var currentTask = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var prevTaskButton: UIButton!
    @IBOutlet weak var nextTaskButton: UIButton!
    @IBOutlet weak var helpMessageLabel: UILabel!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2) // Увеличение прогресс бара
        configureNavigationController() // конфигурация навигационного контроллера
        
        prevTaskButton.isHidden = true
        
        tasks.forEach { attributedTasks.append(createAttributedString($0)) }
        
        updateData() // Обновление данных
        addTapGestureRecognizer() // Запуск обработчика кликов
    }
    
    // Конфигурация навигационного контроллера
    private func configureNavigationController() {
        self.title = cource.title.uppercased()
        configureTheoryButton()
    }
    
    // Кнопка открытия теории
    private func configureTheoryButton() {
        let theoryIcon = UIImage(named: "TheoryIcon")
        let theoryButton = UIBarButtonItem(image: theoryIcon, style: .plain, target: self, action: #selector(openTheory))
        self.navigationItem.rightBarButtonItem = theoryButton
    }
    
    // Обновление данных
    private func updateData() {
        textView.attributedText = attributedTasks[currentTask]
        helpMessageLabel.text = tasks[currentTask].helpMessage
        progressView.progress = Float(currentTask + 1) / Float(tasks.count)
        if nextTaskButton.isHidden {
            nextTaskButton.isHidden = false
            nextTaskButton.isEnabled = true
        }
        if prevTaskButton.isHidden {
            prevTaskButton.isHidden = false
            prevTaskButton.isEnabled = true
        }
        if currentTask == 0 {
            prevTaskButton.isHidden = true
            prevTaskButton.isEnabled = false
        } else if currentTask == tasks.count {
            nextTaskButton.isHidden = true
            nextTaskButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    // Следующее задание
    @IBAction func nextTask(_ sender: Any) {
        if (currentTask == attributedTasks.count - 1) {
            checkResult()
            return
        }
        guard currentTask < attributedTasks.count else { return }
        currentTask += 1
        if (currentTask == attributedTasks.count - 1) {
            nextTaskButton.setTitle("ПРОВЕРИТЬ", for: .normal)
            nextTaskButton.backgroundColor = nextTaskButton.backgroundColor?.darker(by: 5)
        }
        updateData()
    }
    
    // Предыдущее задание
    @IBAction func prevTask(_ sender: Any) {
        if (currentTask == attributedTasks.count - 1) {
            nextTaskButton.setTitle("ДАЛЕЕ", for: .normal)
            nextTaskButton.backgroundColor = UIColor(named: "SecondColor")
        }
        guard currentTask > 0 else { return }
        currentTask -= 1
        updateData()
    }
    
    // Открытие теории
    @objc func openTheory() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TheoryViewController")
        self.present(controller, animated: true)
    }
    
    // Проверка задания
    func checkTask(_ number: Int) -> Bool {
        let task = tasks[number] // Задание
        
        for substring in task.keySubstrings { // Все ключевые слова
            let range = NSRange(location: substring.position, length: substring.changedValue.count)
            let attributes = attributedTasks[number].attributes(at: substring.position, longestEffectiveRange: nil, in: range)
            
            for attribute in attributes {
                if let substring = attribute.value as? LessonTaskSubstring,
                    !checkKeyword(substring, attributes) {
                    return false
                }
            }
        }
        
        return true
    }
    
    // Проверка общего результата
    func checkResult() {
        var goodCount = 0
        let count = tasks.count
        for number in 0..<count {
            if (checkTask(number)) {
                goodCount += 1
            }
        }
        showJustAlert(title: "Результат", message: "Верно \(goodCount) из \(count)") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Taps
    
    // Добавление обработчика нажатий
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProcessing(sender:)))
        tap.delegate = self
        textView.addGestureRecognizer(tap)
    }
    
    // Обработка нажатия на textView
    @objc func tapProcessing(sender: UITapGestureRecognizer) {
        guard let tappedTextView = sender.view as? UITextView else { return }
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: tappedTextView)
        location.x -= tappedTextView.textContainerInset.left;
        location.y -= tappedTextView.textContainerInset.top;
        
        // character index at tap location
        let layoutManager = tappedTextView.layoutManager
        let characterIndex = layoutManager.characterIndex(for: location, in: tappedTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < tappedTextView.textStorage.length {
            
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            
            // check if the tap location has a certain attributemyRange
            let attributes = tappedTextView.attributedText.attributes(at: characterIndex, longestEffectiveRange: nil, in: myRange)
            
            for attribute in attributes {
                if let substring = attribute.value as? LessonTaskSubstring {
                    tapOnKeywordProcessing(keyword: substring, attributes: attributes)
                }
            }
            
        }
    }
    
}

// MARK: - Substrings
extension LessonViewController {
    
    private func changeSubstring(taskIndex: Int, substring: LessonTaskSubstring, value: String) -> LessonTaskSubstring {
        let subIndex = tasks[taskIndex].keySubstrings.firstIndex(of: substring)!
        tasks[taskIndex].keySubstrings[subIndex].changedValue = value
        let newSubstring = tasks[taskIndex].keySubstrings[subIndex]
        let range = NSRange(location: newSubstring.position, length: newSubstring.changedValue.count)
        if (self.attributedTasks.count > taskIndex) {
            attributedTasks[taskIndex].addAttribute(.init(rawValue: newSubstring.uniqueValue()), value: newSubstring, range: range)
            let oldRange = NSRange(location: substring.position, length: substring.changedValue.count)
            attributedTasks[taskIndex].replaceCharacters(in: oldRange, with: newSubstring.changedValue)
        }
        return tasks[taskIndex].keySubstrings[subIndex]
    }
    
    // Создание аттрибута
    private func createAttributedString(_ lessonTask: LessonTask) -> NSMutableAttributedString {
        
        let string = NSMutableAttributedString(string: lessonTask.text)
        string.addAttribute(.font, value: UIFont(name: "Lato", size: 20)!, range: NSRange(location: 0, length: lessonTask.text.count))
        
        for substring in lessonTask.keySubstrings {
            var range = NSRange(location: substring.position, length: substring.changedValue.count)
            string.addAttribute(.init(rawValue: substring.uniqueValue()), value: substring, range: range)
            switch substring.type {
            case .input:
                let taskIndex = tasks.firstIndex(of: lessonTask)!
                let newValue = String(repeating: " ", count: 5)
                let newSubstring = changeSubstring(taskIndex: taskIndex, substring: substring, value: newValue)
                string.replaceCharacters(in: range, with: newSubstring.changedValue)
                range.length = newSubstring.changedValue.count
                string.addAttributes([
                    .underlineColor : UIColor.red,
                    .underlineStyle : NSUnderlineStyle.single.rawValue
                    ], range: range)
                break;
            case .find:
                let color = UIColor(named: "UnselectedColor")!
                string.addAttributes([
                    .backgroundColor : color
                    ], range: range)
                string.addAttribute(.init(rawValue: substring.uniqueValue()), value: substring, range: range)
            }
        }
        
        return string
        
    }
    
    // Обработка нажатия на ключевое слово
    private func tapOnKeywordProcessing(keyword: LessonTaskSubstring, attributes: [NSAttributedString.Key: Any]) {
        let range = NSRange(location: keyword.position, length: keyword.changedValue.count)
        switch keyword.type {
        case .input:
            let index = keyword.answers.firstIndex { (answer: LessonTaskAnswer) -> Bool in
                return keyword.changedValue == answer.value
            }
            var newAnswer: LessonTaskAnswer
            if (index == keyword.answers.count - 1) {
                newAnswer = keyword.answers[0]
            } else {
                newAnswer = keyword.answers[index! + 1]
            }
            _ = changeSubstring(taskIndex: currentTask, substring: keyword, value: newAnswer.value)
            break;
        case .find:
            guard let attr = getAttributeFrom(attributes, key: .backgroundColor) as! UIColor? else { return }
            let unselColor = UIColor(named: "UnselectedColor")!
            if (attr == unselColor) {
                let color = UIColor(named: "MainColor")!
                attributedTasks[currentTask].addAttribute(.backgroundColor, value: color, range: range)
                attributedTasks[currentTask].addAttribute(.foregroundColor, value: UIColor.white, range: range)
            } else {
                let color = unselColor
                attributedTasks[currentTask].addAttribute(.backgroundColor, value: color, range: range)
                attributedTasks[currentTask].addAttribute(.foregroundColor, value: UIColor.black, range: range)
            }
            break;
        }
        textView.attributedText = attributedTasks[currentTask]
    }
    
    // Проверка ключевого слова
    private func checkKeyword(_ keyword: LessonTaskSubstring, _ attributes: [NSAttributedString.Key: Any]) -> Bool {
        switch keyword.type {
        case .input:
            return keyword.isCorrectAnswer(value: keyword.changedValue)
        case .find:
            guard let attr = getAttributeFrom(attributes, key: .backgroundColor) as? UIColor else { return false }
            let unselColor = UIColor(named: "UnselectedColor")!
            if (attr == unselColor && keyword.answers[0].isCorrect) {
                return false
            }
            return true
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
    
}
