//
//  LessonViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit
import PanModal

class LessonViewController: UIViewController, UIGestureRecognizerDelegate, AlertDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var prevTaskButton: UIButton!
    @IBOutlet weak var nextTaskButton: UIButton!
    @IBOutlet weak var helpMessageLabel: UILabel!
    
    let tasks = [
        LessonTask(helpMessage: "Выберите правильное окончание", text: "Мы долго любовались этой прекрасной рекой",
                   keySubstrings: [
                    LessonTaskSubstring(value: "ой", position: 39, type: .input): [
                        LessonTaskAnswer(value: "ой", isCorrect: true),
                        LessonTaskAnswer(value: "ый", isCorrect: false)
                    ]
            ]),
        LessonTask(helpMessage: "Найдите существительные в творительном падеже",
                   text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
                   keySubstrings: [
                    LessonTaskSubstring(value: "спортом", position: 72, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 90, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "командой", position: 169, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 215, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ]
            ]),
        LessonTask(helpMessage: "Найдите существительные в творительном падеже",
                   text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
                   keySubstrings: [
                    LessonTaskSubstring(value: "спортом", position: 72, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 90, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "командой", position: 169, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 215, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ]
            ]),
        LessonTask(helpMessage: "Найдите существительные в творительном падеже",
                   text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
                   keySubstrings: [
                    LessonTaskSubstring(value: "спортом", position: 72, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 90, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "командой", position: 169, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: false)
                    ],
                    LessonTaskSubstring(value: "футболом", position: 215, type: .find): [
                        LessonTaskAnswer(value: "", isCorrect: true)
                    ]
            ])
    ]
    
    var attributedTasks: [NSMutableAttributedString]! = []
    var cource: YLCourceModel!
    var currentTask = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)
        configureNavigationController()
        
        prevTaskButton.isHidden = true
        
        for task in tasks {
            attributedTasks?.append(createAttributedString(task))
        }
        
        updateData()
        addTapGestureRecognizer()
    }
    
    func configureNavigationController() {
        self.title = cource.title.uppercased()
        let theoryButton = UIBarButtonItem(image: UIImage(named: "TheoryIcon"), style: .plain, target: self, action: #selector(openTheory))
        self.navigationItem.rightBarButtonItem = theoryButton
    }
    
    func checkTask(_ number: Int) -> Bool {
        let task = tasks[number];
        for substring in task.keySubstrings {
            let range = NSRange(location: substring.key.position, length: substring.key.value.count)
            let attributes = attributedTasks[number].attributes(at: substring.key.position, longestEffectiveRange: nil, in: range)
            
            for attribute in attributes {
                if let substring = attribute.value as? LessonTaskSubstring {
                    switch substring.type {
                    case .input:
                        return false;
                    case .find:
                        for attr in attributes {
                            if attr.key == .backgroundColor {
                                let unselColor = UIColor(named: "UnselectedColor")!
                                if (attr.value as! UIColor == unselColor && tasks[currentTask].keySubstrings[substring]![0].isCorrect) {
                                    return false;
                                }
                            }
                        }
                    }
                    textView.attributedText = attributedTasks![currentTask]
                }
            }
        }
        
        return true;
    }
    
    func checkResult() {
        var goodCount = 0;
        let count = tasks.count;
        for number in 0..<count {
            if (checkTask(number)) {
                goodCount += 1;
            }
        }
        showJustAlert(title: "\(goodCount) / \(count)");
    }
    
    @IBAction func nextTask(_ sender: Any) {
        if (currentTask == attributedTasks.count - 1) {
            checkResult()
            return
        }
        guard currentTask < attributedTasks.count else { return }
        currentTask += 1
        updateData()
    }
    
    @IBAction func prevTask(_ sender: Any) {
        guard currentTask > 0 else { return }
        currentTask -= 1
        updateData()
    }
    
    func updateData() {
        textView.attributedText = attributedTasks![currentTask]
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
    
    @objc func openTheory() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TheoryViewController")
        self.presentPanModal(controller as! UIViewController & PanModalPresentable)
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProcessing(sender:)))
        tap.delegate = self
        textView.addGestureRecognizer(tap)
    }
    
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
                    let range = NSRange(location: substring.position, length: substring.value.count)
                    switch substring.type {
                    case .input:
                        break;
                    case .find:
                        for attr in attributes {
                            if attr.key == .backgroundColor {
                                let unselColor = UIColor(named: "UnselectedColor")!
                                if (attr.value as! UIColor == unselColor) {
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
                        }
                    }
                    textView.attributedText = attributedTasks![currentTask]
                }
            }
            
        }
    }
    
}

func createAttributedString(_ lessonTask: LessonTask) -> NSMutableAttributedString {
    
    let string = NSMutableAttributedString(string: lessonTask.text)
    string.addAttribute(.font, value: UIFont(name: "Lato", size: 20)!, range: NSRange(location: 0, length: lessonTask.text.count))
    
    for substring in lessonTask.keySubstrings {
        let range = NSRange(location: substring.key.position, length: substring.key.value.count)
        string.addAttribute(.init(rawValue: substring.key.uniqueValue()), value: substring.key, range: range)
        switch substring.key.type {
        case .input:
            string.addAttributes([
                .underlineColor : UIColor.red,
                .underlineStyle : NSUnderlineStyle.single.rawValue,
                .foregroundColor : UIColor.clear
                ], range: range)
            break;
        case .find:
            let color = UIColor(named: "UnselectedColor")!
            string.addAttributes([
                .backgroundColor : color
                ], range: range)
        }
    }
    
    return string
    
}
