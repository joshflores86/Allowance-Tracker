//
//  BillsAndRewards.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/13/23.
//

import SwiftUI

struct BillsAndRewards: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    
    @State private var selectedValue: String?
    //    @State var step = 0
    @State var currency: String = ""
    @State var showCustomBillAlert = false
    @State var showCustomRewardAlert = false
    @State var billsTextFieldValue: String = ""
    @State var rewardTextFieldValue: String = ""
    
    
    var body: some View {
        NavigationView {
            
            ZStack{
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        
                        if dataViewModel.steps >= 1 {
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
                        }
                        HStack{
                            Spacer()
                            Stepper(value: $dataViewModel.steps, in: 0...50) {}
                        }
                        ForEach(0..<dataViewModel.steps, id: \.self) { index in
                            HStack{
                                VStack{
                                    Picker("", selection: $dataViewModel.firstValue[index]) {
                                        ForEach(dataViewModel.billsArray.keys.sorted(), id: \.self ) { key in
                                            Text(key)}}
                                    if dataViewModel.firstValue[index] != "-" {
                                        Picker("", selection: $dataViewModel.secondValue[index]) {
                                            ForEach(dataViewModel.billsArray[dataViewModel.firstValue[index]]!, id: \.self) { value in
                                                Text(value)
                                                    
                                            }
                                        }
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 120)
                                    }
                                }
                                TextField("Enter Amount", text: $dataViewModel.valuePlacer[index]).tag(index)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: dataViewModel.valuePlacer[index]) { newValue in
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
                                                dataViewModel.valuePlacer[index] = formattedString
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Save") {
                                dataViewModel.addSecValue()
                                dataViewModel.addInitialValue()
                                dataViewModel.addValueToArray()
                                
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                dataViewModel.dismissKeyboard()
                            }
                        }
                    }
                }
                
                .padding()
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Bills And Rewards")
                        .font(Font.custom("Lobster-Regular", size: 40))
                        .navigationBarTitleDisplayMode(.large)
                        .padding(.top)
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
        
    }
    
    func printer() {
        print(dataViewModel.steps)
        print(dataViewModel.firstValue)
        print(dataViewModel.valuePlacer)
        print(dataViewModel.secondValue)
        
    }
}

struct BillsAndRewards_Previews: PreviewProvider {
    @State private static var userInfo = UserModel(id: UUID(),
                                                   name: "",
                                                   amount: "",
                                                   initialValue: [],
                                                   valueHolder: [],
                                                   steps: 0)
    static var previews: some View {
        NavigationView {
            ZStack{
                VStack{
                    BillsAndRewards()
                }
            }
            .environmentObject(DataViewModel(usersInfo: userInfo))
            
        }
        
    }
}
