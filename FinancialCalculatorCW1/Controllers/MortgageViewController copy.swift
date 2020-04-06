//
//  MortgageViewController.swift
//  FinancialCalculatorCW1
//
//  Created by Devon Wijesinghe on 2/27/20.
//  Copyright © 2020 Devon Wijesinghe. All rights reserved.
//

import UIKit

enum MortgageEntities: Int {
    case mortgageAmount, interest, payment, numOfYears
}

class MortgageViewController: UIViewController, UITextFieldDelegate, TextFieldsWithPrefix {

    @IBOutlet weak var mortgageAmountTf: UITextField!
    @IBOutlet weak var interestTf: UITextField!
    @IBOutlet weak var paymentTf: UITextField!
    @IBOutlet weak var numOfYearsTf: UITextField!
    @IBOutlet weak var keyboard: CustomKeyboard!
    
    // Getting the data from the model
    var mortgageData : Mortgage = Mortgage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        // Loading initial data to textfields
        self.loadTextFieldData()
        
        // adding prefixs to texfields
        self.addPrefix(textfileds: [mortgageAmountTf, paymentTf], type: .currency)
        self.addPrefix(textfileds: [interestTf], type: .percentage)
        self.addPrefix(textfileds: [numOfYearsTf], type: .number)
    }
    
    func loadTextFieldData() {
        // Getting data
        mortgageData.loadDataFromStorage()
        
        // setting the data
        if let mortgageAmount = mortgageData.mortgageAmount, let interest = mortgageData.interest, let payment = mortgageData.payment, let numOfYears = mortgageData.numOfYears {
            mortgageAmountTf.text = String(mortgageAmount)
            paymentTf.text = String(payment)
            interestTf.text = String(interest)
            numOfYearsTf.text = String(numOfYears)
            
        }
    }
    
    func assignDelegates() {
        mortgageAmountTf.delegate = self
        interestTf.delegate = self
        paymentTf.delegate = self
        numOfYearsTf.delegate = self
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
        
        switch MortgageEntities(rawValue: sender.tag)! {
            case .mortgageAmount:
                mortgageData.mortgageAmount = doubleTextFieldValue
            case .interest:
                mortgageData.interest = doubleTextFieldValue
            case .payment:
                mortgageData.payment = doubleTextFieldValue
            case .numOfYears:
                mortgageData.numOfYears = doubleTextFieldValue
        }
    }
    
    @IBAction func onCalculatePressed(_ sender: Any) {
        
        if (mortgageData.canCalculate()) {
            let valueCalculated = mortgageData.calculateMissingValue().0
            let valueCalculatedType = mortgageData.calculateMissingValue().1
 
            switch valueCalculatedType {
                case "mortgageAmount":
                    mortgageAmountTf.text = String(valueCalculated)
                    mortgageData.mortgageAmount = valueCalculated
                case "interest":
                    interestTf.text = String(valueCalculated)
                    mortgageData.interest = valueCalculated
                case "payment":
                    paymentTf.text = String(valueCalculated)
                    mortgageData.payment = valueCalculated
                case "numOfYears":
                    numOfYearsTf.text = String(valueCalculated)
                    mortgageData.numOfYears = valueCalculated
                default:
                    print("Default")
            }
            
            // Saving data
            mortgageData.saveDataToStorage()
            
        } else {
            let alert = UIAlertController(title: "Invalid Calculation", message: "You have to leave only one field empty!", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(done)
            present(alert, animated: true, completion: nil)
        }
    }
}

