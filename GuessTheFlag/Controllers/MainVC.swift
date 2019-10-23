//
//  MainVC.swift
//  GuessTheFlag
//
//  Created by Jeffrey Lai on 7/26/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

//Challenge:
//1) Try showing the player's score in the navigation bar, alongside the flag to guess.
//2) Keep track of how many questions have been asked, and show one final alert after they have answered 10.
//3) When someone chooses the wrong flag, tell them their mistake in your alert message

import UIKit

class MainVC: UIViewController {

    //Views
    let button1: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 200, height: 100)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 0
        return button
    }()
    
    let button2: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 200, height: 100)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 1
        return button
    }()
    
    let button3: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 200, height: 100)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.tag = 2
        return button
    }()
    
    let stackedButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    
    //Variables
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionCount = 0
    var totalCorrectAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
        self.askQuestion(action: nil)
        
        self.setupViews()
        self.setupNavigationController()
        self.setupContraints()
    }
    
    
    //Functions
    func setupData() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2) //Value between 0, 1, 2
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        
        button1.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        //Increment Question Count
        questionCount += 1
    }
    
    func setupViews() {
        //Background of Main Screen
        self.view.backgroundColor = .white
        
        //Add Buttons
        stackedButtons.addArrangedSubview(button1)
        stackedButtons.addArrangedSubview(button2)
        stackedButtons.addArrangedSubview(button3)
        
        self.view.addSubview(stackedButtons)
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
    }
    
    func setupContraints() {
        stackedButtons.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackedButtons.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc fileprivate func buttonTapped(sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            totalCorrectAnswer += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        updateScore()
        
        if (questionCount % 10) == 0 {
            alertAfterAnsweringQuestions()
        } else {
            alertAfterAnswer(answer: title)
        }
        
    }
    
    fileprivate func updateScore() {
        //Show score in the navigation bar
        let scoreButton = UIBarButtonItem.init(title: "Score: \(score)", style: .plain, target: self, action: nil)
        scoreButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        scoreButton.tintColor = UIColor.black
        scoreButton.target = self
        scoreButton.action = #selector(showScore)
        navigationItem.rightBarButtonItem = scoreButton
        
    
        let questionButton = UIBarButtonItem.init(title: "Q: \(questionCount)/10", style: .plain, target: self, action: nil)
        questionButton.isEnabled = false
        questionButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .disabled)
        questionButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = questionButton
    }
    
    fileprivate func alertAfterAnswer(answer: String) {

        if answer == "Correct" {
            let answerAlert = UIAlertController(title: answer, message: "Your current score is \(score)", preferredStyle: .alert)
            answerAlert.addAction(UIAlertAction(title: "Coninue", style: .default, handler: askQuestion))
            present(answerAlert, animated: true)
        } else if answer == "Wrong" {
            let answerAlert = UIAlertController(title: answer, message: "\(title!) is flag number \(correctAnswer + 1).\n Your current score is \(score)", preferredStyle: .alert)
            answerAlert.addAction(UIAlertAction(title: "Coninue", style: .default, handler: askQuestion))
            present(answerAlert, animated: true)
        }
        

    }
    
    fileprivate func alertAfterAnsweringQuestions() {
        let questionsAlert = UIAlertController(title: "Game Completed", message: "You got \(percentAnswered())% of the questions correct. Your final score is \(score)", preferredStyle: .alert)
        questionsAlert.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
        present(questionsAlert, animated: true)
        
        resetGame()
    }
    
    fileprivate func resetGame() {
        //Reset
        score = 0
        totalCorrectAnswer = 0
        
        updateScore()
        
        questionCount = 0
    }
    
    fileprivate func percentAnswered() -> String {
        let percent = Double(totalCorrectAnswer) / Double(questionCount) * 100.0
        return String(format: "%.2f", percent)
    }
    
    @objc fileprivate func showScore() {
        let alertScore = UIAlertController(title: "Current Score", message: "Each correct answer is +1 and each wrong answer is -1.\n Currently you answered \(percentAnswered())% correctly.\n Your current score is \(score)", preferredStyle: .alert)
        alertScore.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(alertScore, animated: true)
    }

}
