//
//  EditBillsRewardsView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/27/23.
//

import SwiftUI

struct EditBillsRewardsView: View {
    @StateObject var dataViewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    
    @State private var selectedValue: String?
    @State var steps: Int
    @State var firstValue: [String]
    @State var secondValue: [String]
    @State var mainValue: [String]
    @State var currency: String = ""
    @State var showCustomBillAlert = false
    @State var showCustomRewardAlert = false
    @State var billsTextFieldValue: String = ""
    @State var rewardTextFieldValue: String = ""
    @State var id: UUID
    @Binding var specificUser: UserModel
    @State var showConfirmSheet: Bool = false
    let spacer: String = "-"
    var index: Array<UserModel>.Index {
        dataViewModel.usersInfoArray.firstIndex(where: {$0.id == self.id})!
    }
    
    
    var body: some View {
        NavigationView {
            ZStack{
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        
                        HStack{
                            Button {
                                showCustomBillAlert = true
                            } label: {
                                Image(systemName: "dollarsign.circle")
                                    .imageScale(.large)
                            }
                            Spacer()
                            Button {
                                showCustomRewardAlert = true
                            } label: {
                                Image(systemName: "gift")
                                    .imageScale(.large)
                            }
                        }
                        .padding()
                        
                        HStack{
                            Spacer()
                            Stepper("", value: $steps, in: 0...20, step: 1) { _ in
                                if steps + 2 < firstValue.count {
                                    firstValue.removeLast()
                                    secondValue.removeLast()
                                    mainValue.removeLast()
                                }else{
                                    firstValue.append(spacer)
                                    secondValue.append(spacer)
                                    mainValue.append(spacer)
                                }
                            }
                            .onChange(of: steps) { _ in
                                
                                printer()
                            }
                        }
                        ForEach(0..<steps, id: \.self) { index in
                            HStack{
                                VStack{
                                    Picker("", selection: $firstValue[index]) {
                                        ForEach(dataViewModel.billsArray.keys.sorted(), id: \.self ) { key in
                                            Text(key).tag(key)}}
                                    if firstValue[index] != "-" {
                                        Picker("Reward", selection: $secondValue[index]) {
                                            ForEach(dataViewModel.billsArray[firstValue[index]]!, id: \.self) { value in
                                                Text(value).tag(value)
                                            }
                                        }
                                    }
                                }
                                TextField("Enter Amount", text: $mainValue[index]).tag(index)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: mainValue[index]) { newValue in
                                        // Remove non-numeric characters
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        
                                        // Convert to a numeric value
                                        if let amount = Int(filtered) {
                                            // Convert to decimal value
                                            let decimalAmount = Double(amount) / 100.0
                                            
                                            // Format as currency string
                                            let formatter = NumberFormatter()
                                            formatter.numberStyle = .currency
                                            formatter.currencyCode = "USD"
                                            formatter.currencySymbol = ""
                                            
                                            if let formattedString = formatter.string(from: NSNumber(value: decimalAmount)) {
                                                // Update the amountString with the formatted currency value
                                                mainValue[index] = formattedString
                                            }
                                        }
                                    }
                            }
                        }
                        
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                dataViewModel.dismissKeyboard()
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear{
                for _ in specificUser.initialValue {
                    firstValue.append(spacer)
                }
                for _ in specificUser.secondValue {
                    secondValue.append(spacer)
                }
                for _ in specificUser.valueHolder {
                    mainValue.append(spacer)
                }
                //                print(firstValue)
                //                print(secondValue)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showConfirmSheet.toggle()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .actionSheet(isPresented: $showConfirmSheet) {
                dataViewModel.confirmBillRewardsActionSheet(index: index,
                                                 firstValue: firstValue,
                                                 secondValue: secondValue,
                                                 mainValue: mainValue,
                                                 steps: steps)
            }
        }
        
        .alert("Enter Custom Bill", isPresented: $showCustomBillAlert) {
            TextField("Custom Bill", text: $billsTextFieldValue)
            Button("Save") {
                if billsTextFieldValue != "" {
                    dataViewModel.billsArray["Bills"]?.append(billsTextFieldValue)
                    showCustomBillAlert = false
                }else{
                    showCustomBillAlert = false
                }
            }
        }
        .alert("Enter Custom Reward", isPresented: $showCustomRewardAlert) {
            TextField("Custom Bill", text: $rewardTextFieldValue)
            Button("Save") {
                if rewardTextFieldValue != "" {
                    dataViewModel.billsArray["Rewards"]?.append(rewardTextFieldValue)
                    showCustomBillAlert = false
                }else{
                    showCustomBillAlert = false
                }
            }
        }
    }
    
    
    
    func printer() {
        print(firstValue)
        print(secondValue)
        print(mainValue)
        print(steps)
        
    }
}


struct EditBillsRewardsView_Previews: PreviewProvider {
    @State static var userInfo = UserModel(id: UUID(),
                                           name: "",
                                           amount: "",
                                           initialValue: [],
                                           valueHolder: [])
    @State static var dataViewModel = DataViewModel(usersInfo: userInfo)
    static var previews: some View {
        EditBillsRewardsView(dataViewModel: dataViewModel,
                             steps: userInfo.steps,
                             firstValue: [],
                             secondValue: [],
                             mainValue: [],
                             id: userInfo.id,
                             specificUser: $userInfo)
        .environmentObject(DataViewModel(usersInfo: userInfo))
    }
}
