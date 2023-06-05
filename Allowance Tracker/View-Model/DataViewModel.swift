//
//  DataViewModel.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import Foundation
import UIKit
import SwiftUI

class DataViewModel: ObservableObject {
    @Published var usersInfo: UsersInfo
    @Published var usersInfoArray: [UsersInfo] = []
    @Published var billsArray: [String] = ["Select type", "Electric", "Water", "Cable", "Internet", "Phone Bill", "Groceries", "Car Loan"]
    @Published var billsAndAmount: [String: Int] = [:]
    @Published var initValue = Array(repeating: "", count: 10)
    @Published var valuePlacer = Array(repeating: "", count: 10)
    @Published var finalAmount: Double = 0.0
    @Published var steps = 0
    @Published var usersCurrency: [String] = ["Currency", "$", "€", "£", "¥", "₣", "₹"]
    @Published var selectedCurrency = "Currency"
    @Published var showAmountAlert = false
    @Published var showBillAlert = false
    @Published var showMissingNameAlert = false
    @Published var showMissingAmountAlert = false
    @Published var showCustomTextAlert = false
    
    init(usersInfo: UsersInfo){
        self.usersInfo = usersInfo
    }
    
    func saveInfo(name: String, amount: String, selectImage: UIImage, initialArray: [String], valueArray: [String], steps: Int, selectedCurrency: String) {
        usersInfoArray.append(UsersInfo(id: UUID(), name: name, amount: amount, avatarImageData: selectImage.pngData(), initialValue: initialArray, valueHolder: valueArray, steps: steps, currency: selectedCurrency))
        
    }
    
    //MARK: - App Storage code
    
    private var documentDirectory: URL {
        get{
            try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
    }
    private var notesFile: URL {
        documentDirectory.appendingPathComponent("usersInfo").appendingPathExtension(for: .json)
    }
    
    func save() throws {
        let data = try JSONEncoder().encode(usersInfoArray)
        try data.write(to: notesFile)
    }
    func load() throws {
        guard FileManager.default.isReadableFile(atPath: notesFile.path) else {return}
        let data = try Data(contentsOf: notesFile)
        usersInfoArray = try JSONDecoder().decode([UsersInfo].self, from: data)
    }
    
    //MARK: - Other Functions
    
    func deleteUsers(indexSet: IndexSet){
        usersInfoArray.remove(atOffsets: indexSet)
    }
    
    func addValueToArray() {
        for i in valuePlacer {
            if i != "" {
                usersInfo.valueHolder.append(i)
                print(usersInfo.valueHolder)
            } else {
                break
            }
            
        }
    }
    
    
    func addInitialValue(){
        for i in initValue {
            if i != "" {
                usersInfo.initialValue.append(i)
                print(usersInfo.initialValue)
            } else {
                break
            }
        }
    }
    
    
    
    
    
    func addFinalPayment() -> String {
        if let specificAmount = usersInfoArray.first(where: { $0.id == usersInfo.id}){
            if specificAmount.amount != "" {
                if let amountValue = Double(specificAmount.amount){
                    print(amountValue)
                    for num in 0...specificAmount.steps{
                        if let initialValue =  Double(specificAmount.initialValue[num]){
                            let sum = amountValue - initialValue
                            finalAmount = sum
                            print(initialValue)
                        }
                    }
                }
            }
        }
        return String(format: "%.2f", finalAmount)
    }
    
    //MARK: - Alert Functions
    
    
    
    
    func showAlert(num: Int, name: String, amount: String, firstValue: [String]) {
        showMissingNameAlert = false
        showMissingAmountAlert = false
        showBillAlert = false
        showAmountAlert = false
        if name == ""{
            showMissingNameAlert = true
        }else if amount == "" {
            showMissingAmountAlert = true
        }else if num == 0 {
            showBillAlert = true
        }else if num != 0 {
            for i in 0..<num {
                if firstValue[i] == "" {
                    showAmountAlert = true
                }
            }
        }else{
            print("Everything worked fine")
        }
    }
    
    
    
}
