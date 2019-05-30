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
        LessonTask(helpMessage: "Выберите правильное окончание", text: "Мы долго любовались этой прекрасной рекой", keySubstrings: [LessonTaskSubstring(value: "ой", position: 39)], type: .input),
        LessonTask(helpMessage: "Найдите существительные в творительном падеже",
                   text: "Меня зовут Марк, мне 19. Я живу в Калининграде, в России. Я интересуюсь спортом, особенно футболом. Мой любимый русский футбольный клуб - \"Динамо\". Я очень горжусь этой командой. Когда мне было 10, я тоже занимался футболом",
                   keySubstrings: [
                    LessonTaskSubstring(value: "спортом", position: 72),
                    LessonTaskSubstring(value: "футболом", position: 90),
                    LessonTaskSubstring(value: "командой", position: 171),
                    LessonTaskSubstring(value: "футболом", position: 215)
            ], type: .find)
    ]
    
    var attributedTasks: [NSAttributedString]! = []
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
    
    @IBAction func nextTask(_ sender: Any) {
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
        } else if currentTask == tasks.count - 1 {
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
                    showJustAlert(title: "Попадение!", message: substring.uniqueValue())
                }
            }
            
        }
    }
    
}

func createAttributedString(_ lessonTask: LessonTask) -> NSAttributedString {
    
    let string = NSMutableAttributedString(string: lessonTask.text)
    string.addAttribute(.font, value: UIFont(name: "Lato", size: 20)!, range: NSRange(location: 0, length: lessonTask.text.count))
    
    for substring in lessonTask.keySubstrings {
        let range = NSRange(location: substring.position, length: substring.value.count)
        string.addAttribute(.init(rawValue: substring.uniqueValue()), value: substring, range: range)
        switch lessonTask.type {
        case .input:
            string.addAttributes([
                .underlineColor : UIColor.red,
                .underlineStyle : NSUnderlineStyle.single.rawValue,
                .foregroundColor : UIColor.clear
                ], range: range)
            break;
        case .find:
            string.addAttributes([
                .backgroundColor : UIColor.red
                ], range: range)
        }
    }
    
    return string
    
}
