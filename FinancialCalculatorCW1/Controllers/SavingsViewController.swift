//
//  SavingsViewController.swift
//  FinancialCalculatorCW1
//
//  Created by Devon Wijesinghe on 2/27/20.
//  Copyright © 2020 Devon Wijesinghe. All rights reserved.
//

import UIKit

enum SavingsEntities: Int {
    case presentValue, interest, paymentValue, futureValue, numOfYears
}

class SavingsViewController: UIViewController, UITextFieldDelegate, TextFieldsWithPrefix {

    @IBOutlet weak var presentValueTf: UITextField!
    @IBOutlet weak var interestTf: UITextField!
    @IBOutlet weak var numberOfCompoundsPerYearTf: UITextField!
    @IBOutlet weak var isBeginningSwitch: UISwitch!
    @IBOutlet weak var paymentValueTf: UITextField!
    @IBOutlet weak var futureValueTf: UITextField!
    @IBOutlet weak var numberOfYearsTf: UITextField!
    @IBOutlet weak var keyboard: CustomKeyboard!
    
    // Getting the data from the model
    var savingsData : Savings = Savings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        // Loading initial data to textfields
        self.loadTextFieldData()
        
        // adding prefixs to texfields
        self.addPrefix(textfileds: [presentValueTf, futureValueTf, paymentValueTf], type: .currency)
        self.addPrefix(textfileds: [interestTf], type: .percentage)
        self.addPrefix(textfileds: [numberOfCompoundsPerYearTf, numberOfYearsTf], type: .number)
    }
    
    func loadTextFieldData() {
        // Getting data
        savingsData.loadDataFromStorage()

        // setting the data
        if let presentValue = savingsData.presentValue, let interest = savingsData.interest, let numberOfCompoundsPerYear = savingsData.numberOfCompoundsPerYear, let paymentValue = savingsData.paymentValue, let futureValue = savingsData.futureValue, let numOfYears = savingsData.numOfYears {

            presentValueTf.text = String(presentValue)
            interestTf.text = String(interest)
            isBeginningSwitch.isOn = savingsData.isBeginning
            paymentValueTf.text = String(paymentValue)
            numberOfCompoundsPerYearTf.text = String(numberOfCompoundsPerYear)
            futureValueTf.text = String(futureValue)
            numberOfYearsTf.text = String(numOfYears)
        }
    }
    
    func assignDelegates() {
        presentValueTf.delegate = self
        interestTf.delegate = self
        paymentValueTf.delegate = self
        futureValueTf.delegate = self
        presentValueTf.delegate = self
        numberOfYearsTf.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeTextField = textField
        textField.inputView = UIView()
    }
    
    @IBAction func onTfValueChange(_ sender: UITextField) {
        var doubleTextFieldValue : Double?
        
        if let textFieldValue = sender.text {
            doubleTextFieldValue = Double(textFieldValue)
        } else {
            doubleTextFieldValue = nil
        }
        
        switch SavingsEntities(rawValue: sender.tag)! {
            case .presentValue:
                savingsData.presentValue = doubleTextFieldValue
            case .interest:
                savingsData.interest = doubleTextFieldValue
            case .paymentValue:
                savingsData.paymentValue = doubleTextFieldValue
            case .futureValue:
                savingsData.futureValue = doubleTextFieldValue
            case .numOfYears:
                savingsData.numOfYears = doubleTextFieldValue
        }
    }
    
    @IBAction func onSwitchValueChange(_ sender: UISwitch) {
        savingsData.isBeginning = sender.isOn
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (savingsData.canCalculate()) {
            let valueCalculated = savingsData.calculateMissingValue().0
            let valueCalculatedType = savingsData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "presentValue":
                    presentValueTf.text = String(valueCalculated)
                    savingsData.presentValue = valueCalculated
                case "interest":
                    let alert = UIAlertController(title: "Not Supported!", message: "Interest calculation is not supported yet!", preferredStyle: .alert)
                    let done = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(done)
                    present(alert, animated: true, completion: nil)
                case "paymentValue":
                    paymentValueTf.text = String(valueCalculated)
                    savingsData.paymentValue = valueCalculated
                case "futureValue":
                    futureValueTf.text = String(valueCalculated)
                    savingsData.futureValue = valueCalculated
                case "numOfYears":
                    numberOfYearsTf.text = String(valueCalculated)
                    savingsData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            savingsData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
}

