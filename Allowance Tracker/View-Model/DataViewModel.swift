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
    @Published var usersInfo: UserModel
    @Published var usersInfoArray: [UserModel] = []
    @Published var billsArray: [String: [String]] = [
        "-": ["-"],
        "Bills": ["-","Electric", "Water", "Cable", "Internet", "Phone Bill", "Groceries", "Car Loan"],
        "Rewards": ["-","Good Grades", "Chores", "Good behavior", "Birthday"]
    ]
    @Published var billsAndAmount: [String: Int] = [:]
    //    @Published var testValue1 = Array(repeating: "Good Behavior", count: 2)
    //    @Published var testPlacer = Array(repeating: "100.00", count: 2)
    @Published var firstValue = Array(repeating: "-", count: 50)
    @Published var secondValue = Array(repeating: "-", count: 50)
    @Published var valuePlacer = Array(repeating: "$", count: 50)
    @Published var finalAmount: String = ""
    @Published var steps = 1
    @Published var usersCurrency: [String] = ["Currency", "$", "€", "£", "¥", "₣", "₹"]
    @Published var selectedCurrency = ""
    @Published var showAmountAlert = false
    @Published var showBillAlert = false
    @Published var showMissingNameAlert = false
    @Published var showMissingAmountAlert = false
    @Published var showCustomTextAlert = false
    @Published var showValue: Bool = false
    @Published var hideButton: Bool = false
    @State var finalPay: String = ""
    
//    @State var totalValueHolder = 0.00
    @State var valueHolder: Double = 0.00
    
    init(usersInfo: UserModel){
        self.usersInfo = usersInfo
    }
    
    func saveInfo(name: String, amount: String, selectImage: UIImage, initialArray: [String], secondValue: [String] , valueArray: [String], steps: Int, selectedCurrency: String) {
        usersInfoArray.append(UserModel(id: UUID(), name: name, amount: amount, avatarImageData: selectImage.pngData(), initialValue: initialArray, secondValue: secondValue, valueHolder: valueArray, steps: steps, currency: selectedCurrency))
        
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
        usersInfoArray = try JSONDecoder().decode([UserModel].self, from: data)
    }
    
    //MARK: - Other Functions
    
    func deleteUsers(indexSet: IndexSet){
        usersInfoArray.remove(atOffsets: indexSet)
    }
    
    func addValueToArray() {
        for i in valuePlacer {
            if i != "$" {
                usersInfo.valueHolder.append(i)
                print(usersInfo.valueHolder)
            } else {
                break
            }
            
        }
    }
    
    func addSecValue(){
        for i in secondValue {
            if i != "-" {
                usersInfo.secondValue.append(i)
                print(usersInfo.initialValue)
            } else {
                break
            }
        }
    }
    
    func addInitialValue(){
        for i in firstValue {
            if i != "-" {
                usersInfo.initialValue.append(i)
                print(usersInfo.initialValue)
            } else {
                break
            }
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
    
    func saveUpdateUserAmount(index: Array<UserModel>.Index) {
        print(index)
        var specificUsers = usersInfoArray[index]
        print(specificUsers)
        specificUsers.amount = finalAmount
        specificUsers.showNoButton = hideButton
        specificUsers.paymentComplete = showValue
        usersInfoArray[index] = specificUsers
        
        try? save()
    }
    
    func addFinalPayment(index: Array<UserModel>.Index) {
        var specificUsers = usersInfoArray[index]
        print(specificUsers)
        if specificUsers.amount != "" {
            if let amountValue = Double(specificUsers.amount.replacingOccurrences(of: ",", with: "")) {
                print(amountValue)
                var totalValueHolder = 0.0
                for num in 0..<specificUsers.valueHolder.count {
                   let valueHolder = Double(specificUsers.valueHolder[num].replacingOccurrences(of: ",", with: "")) ?? 0.00
                    print(valueHolder)
                  totalValueHolder += valueHolder
                }
                let sum = amountValue - totalValueHolder
                print(sum)
                finalAmount = formatNumber(sum)
                hideButton.toggle()
                
                print(specificUsers.showNoButton)
                specificUsers.amount = finalAmount
            
                try? save()
            }
        }
    }
    
    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    
    //MARK: - Alert Functions
    
    func getAlert() -> Alert {
        if showMissingNameAlert {
            return Alert(title: Text("Missing Users Name"), message: Text("Please enter name"))
        } else if showMissingAmountAlert {
            return Alert(title: Text("Missing Initial Amount"), message: Text("Please enter users initial amount"))
        } else if showBillAlert {
            return Alert(title: Text("Missing Bill and Amount"), message: Text("Please press the '+' to add the type of bill and amount"))
        } else if showAmountAlert {
            return Alert(title: Text("Missing Amount"), message: Text("Please enter amount value"))
        } else {
            return Alert(title: Text(""), message: Text(""))
        }
    }
    
    
    func showAlert(num: Int, name: String, amount: String) {
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
            
        }else{
            print("Everything worked fine")
        }
    }
}

