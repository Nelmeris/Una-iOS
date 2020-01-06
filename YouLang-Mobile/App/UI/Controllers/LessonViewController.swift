//
//  LessonViewController.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 29/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController, UIGestureRecognizerDelegate, AlertDelegate, LessonView {
    
    // MARK: - Properties
    private var presenter: LessonViewPresenter!
    
    var cource: YLCourceModel!
    private var viewModel: LessonViewModel!
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var helpMessageLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var prevTaskButton: UIButton!
    @IBOutlet weak var nextTaskButton: UIButton!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizer() // Запуск обработчика кликов
        configureProgressView()
        configureNavigationController() // конфигурация навигационного контроллера
        
        presenter = LessonPresenter(view: self)
        presenter.showLesson()
    }
    
    // Прогресс бара
    private func configureProgressView() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2) // Увеличение прогресс бара
    }
    
    // Навигационная панель
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
    
    // MARK: - Actions
    
    // Следующее задание
    @IBAction func nextTask(_ sender: Any) {
        presenter.showNextTask()
    }
    
    // Предыдущее задание
    @IBAction func prevTask(_ sender: Any) {
        presenter.showPrevTask()
    }
    
    // Открытие теории
    @objc func openTheory() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TheoryViewController")
        self.present(controller, animated: true)
    }
    
    func setTask(_ task: LessonViewModel, isFirst: Bool, isLast: Bool) {
        self.viewModel = task
        setPrevButton(isEnabled: !isFirst)
        configureNextTaskButton(isLast: isLast)
        
        helpMessageLabel.text = task.helpMessage
        textView.attributedText = self.viewModel.attributedText
        progressView.progress = task.progress
    }
    
    func setResult(message: String) {
        showJustAlert(title: "Результат", message: message) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setPrevButton(isEnabled: Bool) {
        prevTaskButton.isHidden = !isEnabled
        prevTaskButton.isEnabled = isEnabled
    }
    
    private func configureNextTaskButton(isLast: Bool) {
        if isLast {
            nextTaskButton.setTitle("ПРОВЕРИТЬ", for: .normal)
            nextTaskButton.backgroundColor = nextTaskButton.backgroundColor?.darker(by: 5)
        } else {
            nextTaskButton.setTitle("ДАЛЕЕ", for: .normal)
            nextTaskButton.backgroundColor = UIColor(named: "SecondColor")
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
                if var substring = attribute.value as? LessonTaskSubstring {
                    presenter.tapOnKeywordProcessing(keyword: &substring)
                }
            }
            
        }
    }
    
}
