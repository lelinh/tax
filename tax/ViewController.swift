//
//  ViewController.swift
//  tax
//
//  Created by Linh Le on 11/16/16.
//  Copyright © 2016 Linh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var grossSalary: UITextField!
    @IBOutlet weak var workingDays: UITextField!
    @IBOutlet weak var lunch: UITextField!
    @IBOutlet weak var parking: UITextField!
    @IBOutlet weak var unionFee: UITextField!
    @IBOutlet weak var PIT: UILabel!
    @IBOutlet weak var insurance: UILabel!
    @IBOutlet weak var NetToHome: UILabel!
    
    let locale = Locale.current

    var salary = 0.0
    var totalIncome = 0.0
    var workingdays = 22
    
    var MealAllowance = 0.0
    var ParkingAllowance = 0.0
    
    var BenefitForTaxPurpose = 0.0
    
    var TaxableIncome = 0.0
    var TaxDeduction = 0.0
    //1. Personal deduction/Giảm trừ bản thân 9,000,000
    var PersonalDeduction = 9000000.0
    //2. Dependants deduction/Giảm trừ cho người phụ thuộc -
    
    
    //3. Social, Health and Unemployment/BHXH, BHYT, BHTN
    var insuranceRate = 0.105
    var insuranceTotal = 0.0
    //Insurance 10.5% paid by employee/10.5% chi trả bởi nhân viên 997,500
    
    var AssessableIncome = 0.0
    var PITmonthly = 0.0
    var AddedPayment = 0.0
    var Deduction = 0.0
    var Union = 15000.0
    var NetTakeHome = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        unionFee.text = String(Int(Union))
        workingDays.text = String(workingdays)
        lunch.text = "35000"
        parking.text = "120000"
        grossSalary.delegate = self
        workingDays.delegate = self
        lunch.delegate = self
        parking.delegate = self
        unionFee.delegate = self
        let currencySymbol = locale.currencySymbol
        let currencyCode = locale.currencyCode
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    //MARK: action
    @IBAction func salaryInput(_ sender: UITextField) {
        calcNET()
    }
    @IBAction func workingDaysInput(_ sender: UITextField) {
        calcNET()
    }
    @IBAction func lunchInput(_ sender: UITextField) {
        calcNET()
    }
    @IBAction func parkingInput(_ sender: UITextField) {
        calcNET()
    }
    @IBAction func unionFeeInput(_ sender: UITextField) {
        calcNET()
    }
    
    //MARK: core function
    func numberToCurrency(_ curr: Double) -> String {
        var count = 0
        var currInt = Int(curr)
        var outString = ""
        while currInt>0 {
            let units = String((currInt%10))
            outString = units+outString
            currInt = currInt/10
            count = count + 1
            if (count == 3)&&(currInt>0) {
                count = 0
                print("currInt \(currInt)")
                outString = ","+outString
            }
        }
        return outString
    }
    
    func calcTotalIncome() {
        totalIncome = salary + MealAllowance + ParkingAllowance
    }
    
    func calcPIT() {
        insuranceTotal = salary*insuranceRate
        insurance.text = "Insurance:      "+(locale.currencySymbol!)+numberToCurrency(insuranceTotal)
        TaxableIncome = totalIncome - PersonalDeduction - insuranceTotal - MealAllowance
        print("taxableIncome: \(TaxableIncome)")
        if TaxableIncome>5000000 {
            PITmonthly = TaxableIncome*0.1 - 250000
        }else if TaxableIncome>0{
            PITmonthly = TaxableIncome*0.05
        }else{
            PITmonthly = 0
        }
        PIT.text = "PIT:           "+(locale.currencySymbol!)+numberToCurrency((PITmonthly))
        print((PITmonthly))
    }
    func calcNET() {
        salary = Double((grossSalary.text == "") ? "0" : grossSalary.text!)!/22*Double((workingDays.text == "") ? "0" : workingDays.text!)!
        MealAllowance = Double((workingDays.text == "") ? "0" : workingDays.text!)!*Double((lunch.text == "") ? "0" : lunch.text!)!
        ParkingAllowance = Double(parking.text ?? "0")!
        
        calcTotalIncome()
        calcPIT()
        NetTakeHome = totalIncome - insuranceTotal - PITmonthly - Union
        print("nettakehome: \(NetTakeHome)")
        print("nettakehome_String: \(numberToCurrency(NetTakeHome))")
        NetToHome.text = (locale.currencySymbol!)+(numberToCurrency(NetTakeHome))
        
    }



}

