//
//  EntryView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI
import UIKit


struct EntryView: View {
    
    @StateObject var dataViewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @State var showImagePicker = false
    @State var showBillsRewardSheet = false
    @State var userName: String = ""
    @State var givenAmount: String = ""
    @State var avatarImage = UIImage(named: "default-avatar")!
    @State var step = 2
    
    @State var showCustomTextAlert = false
    @State var textFieldValue: String = ""
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
                backgroundColor
                    .ignoresSafeArea()
                
                VStack{
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .onTapGesture {
                            showImagePicker = true
                        }
                    VStack{
                        TextField("Enter Name", text: $userName)
                            .autocapitalization(.words)
                        TextField("Enter Amount", text: $givenAmount)
                            .keyboardType(.decimalPad)
                    }
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    
                    .onChange(of: givenAmount) { newValue in
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
                                givenAmount = formattedString
                            }
                        }
                    }
                    VStack{
                        
                        if dataViewModel.secondValue[0] == "-" {
                            EmptyListView_2()
                        }else{
                            List {
                                ForEach(0..<dataViewModel.steps, id: \.self) { index in
                                    HStack{
                                        VStack{Text(dataViewModel.secondValue[index])}
                                        Spacer()
                                        Text("$ \(dataViewModel.valuePlacer[index])")
                                    }
                                    
                                }
                                .listRowBackground(backgroundColor)
                            }
                        }
                    }
                    
                    .alert(isPresented: getAlertBinding(), content: {dataViewModel.getAlert()})
                    .sheet(isPresented: $showBillsRewardSheet) {
                        BillsAndRewards()
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $avatarImage)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Save") {
                            dataViewModel.showAlert(num: step, name: userName, amount: givenAmount)
                            if !dataViewModel.showMissingNameAlert && !dataViewModel.showAmountAlert{
                                dataViewModel.saveInfo( name: userName, amount: givenAmount, selectImage: avatarImage,
                                                        initialArray: dataViewModel.usersInfo.initialValue, secondValue:
                                                            dataViewModel.usersInfo.secondValue,valueArray: dataViewModel.usersInfo.valueHolder,
                                                        steps: dataViewModel.steps)
                                
                                dataViewModel.firstValue = Array(repeating: "-", count: 50)
                                dataViewModel.secondValue = Array(repeating: "-", count: 50)
                                dataViewModel.valuePlacer = Array(repeating: " ", count: 50)
                                dataViewModel.steps = 1
                                try! dataViewModel.save()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
                .padding(.top)
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
        .navigationBarItems(trailing: Button {
            showBillsRewardSheet = true
        } label: {
            Image(systemName: "square.and.pencil")
        })
        
    }
    
    
    private func getAlertBinding() -> Binding<Bool> {
        if dataViewModel.showMissingNameAlert {
            return $dataViewModel.showMissingNameAlert
        } else if dataViewModel.showMissingAmountAlert {
            return $dataViewModel.showMissingAmountAlert
        } else if dataViewModel.showBillAlert {
            return $dataViewModel.showBillAlert
        } else if dataViewModel.showAmountAlert {
            return $dataViewModel.showAmountAlert
        } else {
            return Binding.constant(false)
        }
    }
    
}
struct AddUserView_Previews: PreviewProvider {
    @State private static var userInfo = UserModel(id: UUID(), name: "", amount: "",
                                                   valueHolder: [], steps: 0)
    @StateObject var dataViewModel: DataViewModel
    static var previews: some View {
        VStack{
            
            EntryView(dataViewModel: DataViewModel(usersInfo: userInfo))
                .environmentObject(DataViewModel(usersInfo: userInfo))
        }
        
        
        
        
    }
}

