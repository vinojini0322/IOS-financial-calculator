//
//  CompoundSavingsViewController.swift
//  FinancialCalculatorCW1
//
//  Created by Devon Wijesinghe on 2/27/20.
//  Copyright © 2020 Devon Wijesinghe. All rights reserved.
//

import UIKit

enum CompoundSavingsEntities: Int {
    case presentValue, interest, futureValue, numOfYears
}

class CompoundSavingsViewController: UIViewController, UITextFieldDelegate, TextFieldsWithPrefix {

    @IBOutlet weak var presentValueTf: UITextField!
    @IBOutlet weak var interestTf: UITextField!
    @IBOutlet weak var numberOfCompoundsPerYearTf: UITextField!
    @IBOutlet weak var futureValueTf: UITextField!
    @IBOutlet weak var numberOfYearsTf: UITextField!
    @IBOutlet weak var keyboard: CustomKeyboard!
    
    // Getting the data from the model
    var compoundSavingsData : CompoundSavings = CompoundSavings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignDelegates()
        // Loading initial data to textfields
        self.loadTextFieldData()
        
        // adding prefixs to texfields
        self.addPrefix(textfileds: [presentValueTf, futureValueTf], type: .currency)
        self.addPrefix(textfileds: [interestTf], type: .percentage)
        self.addPrefix(textfileds: [numberOfCompoundsPerYearTf, numberOfYearsTf], type: .number)
    }
    
    
    func loadTextFieldData() {
        // Getting data
        compoundSavingsData.loadDataFromStorage()

        // setting the data
        if let presentValue = compoundSavingsData.presentValue, let interest = compoundSavingsData.interest, let numberOfCompoundsPerYear = compoundSavingsData.numberOfCompoundsPerYear, let futureValue = compoundSavingsData.futureValue, let numOfYears = compoundSavingsData.numOfYears {

            presentValueTf.text = String(presentValue)
            interestTf.text = String(interest)
            numberOfCompoundsPerYearTf.text = String(numberOfCompoundsPerYear)
            futureValueTf.text = String(futureValue)
            numberOfYearsTf.text = String(numOfYears)
        }
    }
    
    func assignDelegates() {
        presentValueTf.delegate = self
        interestTf.delegate = self
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
        
        switch CompoundSavingsEntities(rawValue: sender.tag)! {
            case .presentValue:
                compoundSavingsData.presentValue = doubleTextFieldValue
            case .interest:
                compoundSavingsData.interest = doubleTextFieldValue
            case .futureValue:
                compoundSavingsData.futureValue = doubleTextFieldValue
            case .numOfYears:
                compoundSavingsData.numOfYears = doubleTextFieldValue
            
        }
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (compoundSavingsData.canCalculate()) {
            let valueCalculated = compoundSavingsData.calculateMissingValue().0
            let valueCalculatedType = compoundSavingsData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "presentValue":
                    presentValueTf.text = String(valueCalculated)
                    compoundSavingsData.presentValue = valueCalculated
                case "interest":
                    interestTf.text = String(valueCalculated)
                    compoundSavingsData.interest = valueCalculated
                case "futureValue":
                    futureValueTf.text = String(valueCalculated)
                    compoundSavingsData.futureValue = valueCalculated
                case "numOfYears":
                    numberOfYearsTf.text = String(valueCalculated)
                    compoundSavingsData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            compoundSavingsData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
}

