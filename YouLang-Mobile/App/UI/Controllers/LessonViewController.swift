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
    private let animationDuration = 0.8
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var helpMessageLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var swipeRightGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeLeftGestureRecognizer: UISwipeGestureRecognizer!
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureRecognizer() // Запуск обработчика кликов
        textView.text = nil
        configureTaskTextView()
        configureProgressView()
        configureNavigationController() // конфигурация навигационного контроллера
        
        presenter = LessonPresenter(view: self)
        presenter.showLesson()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationController()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
        }
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(nil, for: .default)
        navBar?.shadowImage = nil
        navBar?.isTranslucent = false
        navBar?.tintColor = UIColor(named: "MainColor")
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MainColor")!]
    }
    
    // Прогресс бара
    private func configureProgressView() {
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4) // Увеличение прогресс бара
        
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = progressView.layer.frame.size.height / 2
        
        progressView.subviews[1].clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = progressView.layer.frame.size.height / 2
        
        progressView.progress = 0
    }
    
    private func configureTaskTextView() {
        textView.textColor = .white
        textView.textAlignment = .center
    }
    
    // Навигационная панель
    private func configureNavigationController() {
        self.title = cource.title.uppercased()
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navBar?.tintColor = .white
        navBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
    @IBAction func nextTask(_ sender: UISwipeGestureRecognizer) {
        guard sender.state == .ended else { return }
        self.presenter.showNextTask()
    }
    
    // Предыдущее задание
    @IBAction func prevTask(_ sender: UISwipeGestureRecognizer) {
        guard sender.state == .ended else { return }
        presenter.showPrevTask()
    }
    
    // Открытие теории
    @objc func openTheory() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TheoryViewController")
        self.present(controller, animated: true)
    }
    
    func setTask(_ task: LessonViewModel, isFirst: Bool, isLast: Bool) {
        if let viewModel = viewModel,
            viewModel.progress == task.progress {
            setTaskText(task.attributedText)
        } else {
            UIView.animate(withDuration: animationDuration / 2, animations: {
                self.textView.alpha = 0
            }, completion: { animated in
                self.setTaskText(task.attributedText)
                UIView.animate(withDuration: self.animationDuration / 2) {
                    self.textView.alpha = 1
                }
            })
            UIView.animate(withDuration: animationDuration) {
                self.progressView.setProgress(task.progress, animated: true)
            }
            
            setHelpMessage(task.helpMessage)
//            setPrevButton(isEnabled: !isFirst)
//            configureNextTaskButton(isLast: isLast)
        }
        self.viewModel = task
    }
    
    private func setTaskText(_ attributedText: NSMutableAttributedString) {
        textView.attributedText = attributedText
        configureTaskTextView()
    }
    
    private func setHelpMessage(_ message: String) {
        helpMessageLabel.text = "\(message.uppercased()):"
    }
    
    func setResult(message: String) {
        showJustAlert(title: "Результат", message: message) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    private func setPrevButton(isEnabled: Bool) {
//        prevTaskButton.isHidden = !isEnabled
//        prevTaskButton.isEnabled = isEnabled
//    }
//
//    private func configureNextTaskButton(isLast: Bool) {
//        if isLast {
//            nextTaskButton.setTitle("ПРОВЕРИТЬ", for: .normal)
//            nextTaskButton.backgroundColor = nextTaskButton.backgroundColor?.darker(by: 5)
//        } else {
//            nextTaskButton.setTitle("ДАЛЕЕ", for: .normal)
//            nextTaskButton.backgroundColor = UIColor(named: "SecondColor")
//        }
//    }
    
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
