//
//  FirstViewController.swift
//  app-steady
//
//  Created by Andrew Demoleas on 4/6/16.
//  Copyright © 2016 Hawt-Lava. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var questionList:[Question] = []

    var answerPicker = UIPickerView(frame: CGRectMake(100, 400, 200, 100))
    var questionLabel = UILabel(frame: CGRectMake(100, 100, 200, 21))
    var answerLabel = UILabel(frame: CGRectMake(100, 200, 200, 21))
    let nextQuestionButton = UIButton(type: UIButtonType.System)
    
    var mainQuestionIndex = 0
    var mainQuestion : Question = Question(text: "", id: 0)
    let pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeAlamofire()
    }
    
    func initializeAlamofire() {
        Alamofire.request(.GET, "http://localhost:8000/prompts") .responseJSON { response in // 1
            
            let results :NSArray = response.result.value!["results"] as! NSArray
            let firstResult = results[0]
            let text = firstResult["text"]
            let id = firstResult["id"]
            print(text)
            print(id)

            response.result.value
            self.initializeQuestionArray(results)
            self.initializeQuestionLabel()
            self.initializeAnswerPicker()
            self.initializeNextQuestionButton()
        }
    }
    
    func initializeQuestionArray(results :NSArray)
    {
        for result in results{
            let text: String = result["text"] as! String
            let id: NSInteger = result["id"] as! NSInteger
            let question = Question(text: text, id: id)
            questionList.append(question)
            print("success!")
        }
        
    }
    
    func initializeQuestionLabel() {
        questionLabel.textAlignment = NSTextAlignment.Center
//        questionLabel.text = mainQuestion!.askQuestion
        
        questionLabel.text = nextQuestion()?.text
        self.view.addSubview(questionLabel)
    }
    
    func initializeAnswerLabel() {
        answerLabel.textAlignment = NSTextAlignment.Center
        answerLabel.hidden = true
        self.view.addSubview(answerLabel)
    }
    
    func initializeNextQuestionButton () {
        nextQuestionButton.setTitle("Next Question", forState: UIControlState.Normal)
        nextQuestionButton.frame = CGRectMake(100, 600, 200, 21)
        nextQuestionButton.addTarget(self, action: #selector(self.nextQuestionButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(nextQuestionButton)
    }
    
    func initializeAnswerPicker() {
        self.view.addSubview(answerPicker)
        answerPicker.dataSource = self
        answerPicker.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextQuestionButtonPressed(sender: UIButton!) {
        if (mainQuestionIndex == questionList.count)  {
            tabBarController?.selectedIndex = 1
            return
        }
        
        
        
//        self.questionLabel.text = mainQuestion!.askQuestion
        self.answerLabel.hidden = true
        print(self.UUID, self.questionLabel.text!, self.answerLabel.text!)
    }
    
    func nextQuestion() -> Question? {
        
        if questionIndex == questionList.count{
            return nil
        }
        
        let question: Question = questionList[questionIndex] 
        questionIndex += 1
        return question
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        answerLabel.text = pickerData[row]
        answerLabel.hidden = false
    }
}

