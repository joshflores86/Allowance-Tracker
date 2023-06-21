//
//  EntryView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI
import UIKit


struct EntryView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel
    
    
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
            VStack{
                VStack{
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    
                        .padding()
                        .onTapGesture {showImagePicker = true}
                    
                    TextField("Add name", text: $userName)
                        .autocapitalization(.words)
                    TextField("Enter Initial Amount", text: $givenAmount)
                        .padding(.bottom)
                        .keyboardType(.decimalPad)
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
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            dataViewModel.dismissKeyboard()
                        }
                    }
                }
                VStack{
                    if dataViewModel.secondValue[0] == "" {
                        EmptyListView_2()
                        Color(uiColor: UIColor(backgroundColor))
                    }else{
                        List {
                            ForEach(0..<dataViewModel.steps, id: \.self) { index in
                                HStack{
                                    VStack{
                                        Text(dataViewModel.secondValue[index])
                                    }
                                    Spacer()
                                    Text("$ \(dataViewModel.valuePlacer[index])")
                                }
                            }
                            .listRowBackground(Color(uiColor: UIColor(backgroundColor)))
                        }
                    }
                        
                }
                
                .listStyle(.plain)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Save") {
                            dataViewModel.showAlert(num: step, name: userName, amount: givenAmount)
                            
                            if !dataViewModel.showMissingNameAlert && !dataViewModel.showAmountAlert{
                                dataViewModel.saveInfo( name: userName, amount: givenAmount, selectImage: avatarImage,
                                                        initialArray: dataViewModel.usersInfo.initialValue, secondValue: dataViewModel.usersInfo.secondValue,
                                                       valueArray: dataViewModel.usersInfo.valueHolder,
                                                       steps: dataViewModel.steps, selectedCurrency: dataViewModel.selectedCurrency)
                                dataViewModel.firstValue = Array(repeating: "", count: 50)
                                dataViewModel.secondValue = Array(repeating: "", count: 50)
                                dataViewModel.valuePlacer = Array(repeating: "", count: 50)
                                dataViewModel.steps = 0
                                
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
            .background(Color(uiColor: UIColor(backgroundColor)).ignoresSafeArea())
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .environmentObject(dataViewModel)
        .background(Color(uiColor: UIColor(backgroundColor)).ignoresSafeArea())
        
        
        //MARK: - Alerts below
        .alert(isPresented: getAlertBinding(), content: {dataViewModel.getAlert()})
        
        
        .foregroundColor(foregroundColor)
        .toolbar {
            
            ToolbarItem(placement: .automatic) {
                Button {
                    showBillsRewardSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        
        
        
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $avatarImage)
            
        }
        .sheet(isPresented: $showBillsRewardSheet) {
            BillsAndRewards()
        }
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
    
    static var previews: some View {
        NavigationView {
            
            EntryView()
            
        }
        .environmentObject(DataViewModel(usersInfo: userInfo))
        
        
        
    }
}

