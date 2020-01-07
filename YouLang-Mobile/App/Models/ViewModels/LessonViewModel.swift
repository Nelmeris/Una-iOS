//
//  LessonViewModel.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

struct LessonViewModel {
    
    let text: String
    let helpMessage: String
    let progress: Float
    private(set) var substrings: [LessonTaskSubstring]
    
    private(set) var attributedText: NSMutableAttributedString
    
    init(text: String, helpMessage: String, progress: Float, substrings: [LessonTaskSubstring]) {
        self.text = text
        self.helpMessage = helpMessage
        self.progress = progress
        self.substrings = substrings
        attributedText = NSMutableAttributedString(string: self.text)
        createAttributedText()
    }
    
    private mutating func createAttributedText() {
        var range = NSRange(location: 0, length: text.count)
        attributedText.addAttributes([
            .font: UIFont(name: "Lato", size: 24)!],
                                     range: range)
        
        for substring in substrings {
            range = NSRange(location: substring.position, length: substring.value.count)
            attributedText.addAttribute(substring.uniqueValue(), value: substring, range: range)
            
            switch substring.type {
            case .input:
                let newValue = String(repeating: " ", count: 5)
                var newSubstring = substring
                changeSubstring(&newSubstring, value: newValue)
                range.length = newSubstring.changedValue.count
                attributedText.addAttributes([
                    .underlineColor : UIColor.red,
                    .underlineStyle : NSUnderlineStyle.single.rawValue
                    ], range: range)
                break;
            case .find:
                let color = UIColor(named: "UnselectedColor")!
                attributedText.addAttributes([
                    .backgroundColor: color
                    ], range: range)
            }
        }
    }
    
    public mutating func changeSubstring(_ substring: inout LessonTaskSubstring, value: String) {
        let oldRange = NSRange(location: substring.position, length: substring.changedValue.count)
        substring.changedValue = value
        
        guard let subIndex = self.substrings.firstIndex(of: substring) else { return }
        
        let text = attributedText
        text.removeAttribute(substring.uniqueValue(), range: oldRange)
        text.replaceCharacters(in: oldRange, with: substring.changedValue)
        
        substrings[subIndex].changedValue = value
        let range = NSRange(location: substring.position, length: substring.changedValue.count)
        text.addAttribute(substring.uniqueValue(), value: substring, range: range)
        
        attributedText = text
    }
    
    mutating func tapOnKeywordProcessing(keyword: inout LessonTaskSubstring) {
        let range = NSRange(location: keyword.position, length: keyword.changedValue.count)
        let attributedText = self.attributedText
        switch keyword.type {
        case .input:
            let index = keyword.answers.firstIndex { (answer: LessonTaskAnswer) -> Bool in
                return keyword.changedValue == answer.value
            } ?? -1
            var newAnswer: LessonTaskAnswer
            if (index == keyword.answers.count - 1) {
                newAnswer = keyword.answers[0]
            } else {
                newAnswer = keyword.answers[index + 1]
            }
            changeSubstring(&keyword, value: newAnswer.value)
            break;
        case .find:
            guard let attr = attributedText.attribute(.backgroundColor, at: keyword.position, effectiveRange: nil) as? UIColor? else { return }
            let unselColor = UIColor(named: "UnselectedColor")!
            if (attr == unselColor) {
                let color = UIColor(named: "MainColor")!
                attributedText.addAttribute(.backgroundColor, value: color, range: range)
                attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: range)
            } else {
                let color = unselColor
                attributedText.addAttribute(.backgroundColor, value: color, range: range)
                attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            }
            break;
        }
        self.attributedText = attributedText
    }
    
    // Получение определенного атрибута
    private func getAttributeFrom(_ attributes: [NSAttributedString.Key: Any], key: NSAttributedString.Key) -> Any? {
        return attributes.filter { $0.key == key }
    }
    
}

final class LessonViewModelFactory {
    
    func construct(from tasks: [LessonTask]) -> [LessonViewModel] {
        var models: [LessonViewModel] = []
        var number = 0
        tasks.forEach { task in
            number += 1
            models.append(viewModel(from: task, number: number, count: tasks.count))
        }
        return models
    }
    
    private func viewModel(from task: LessonTask, number: Int, count: Int) -> LessonViewModel {
        let text = task.text
        let helpMessage = task.helpMessage
        let progress = Float(number) / Float(count)
        let substrings = task.keySubstrings
        return LessonViewModel(text: text, helpMessage: helpMessage, progress: progress, substrings: substrings)
    }
    
}
