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
    @State var currency: String = ""
    @State var showCustomBillAlert = false
    @State var showCustomRewardAlert = false
    @State var billsTextFieldValue: String = ""
    @State var rewardTextFieldValue: String = ""
    @State var id: UUID
    @Binding var specificUser: UserModel
    
    
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
                            Stepper(value: $steps, in: 0...50) {
                            }
                        }
                        ForEach(0..<steps, id: \.self) { index in
                            HStack{
                                VStack{
                                    Picker("", selection: $specificUser.initialValue[index]) {
                                        ForEach(dataViewModel.billsArray.keys.sorted(), id: \.self ) { key in
                                            Text(key)}}
                                    if specificUser.secondValue[index] != "" {
                                        Picker("Reward", selection: $specificUser.secondValue[index]) {
                                            ForEach(dataViewModel.billsArray[specificUser.initialValue[index]]!, id: \.self) { value in
                                                Text(value)
                                            }
                                        }
                                    }
                                }
                                TextField("Enter Amount", text: $specificUser.valueHolder[index]).tag(index)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: specificUser.valueHolder[index]) { newValue in
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
                                                specificUser.valueHolder[index] = formattedString
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
                
            }
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Bills And Rewards")
//                        .font(Font.custom("Lobster-Regular", size: 40))
//                        .navigationBarTitleDisplayMode(.large)
//                        .padding(.top)
//                }
//            }
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
        print(dataViewModel.steps)
        print(dataViewModel.firstValue)
        print(dataViewModel.valuePlacer)
        print(dataViewModel.secondValue)
        
    }
}


struct EditBillsRewardsView_Previews: PreviewProvider {
    @State static var userInfo = UserModel(id: UUID(), name: "",
                                           amount: "", valueHolder: [])
    @State static var dataViewModel = DataViewModel(usersInfo: userInfo)
    static var previews: some View {
        EditBillsRewardsView(dataViewModel: dataViewModel,
                             steps: userInfo.steps, id: userInfo.id, specificUser: $userInfo)
            .environmentObject(DataViewModel(usersInfo: userInfo))
    }
}
