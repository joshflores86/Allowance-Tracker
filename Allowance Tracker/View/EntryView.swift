//
//  EntryView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct EntryView: View {
    
    @EnvironmentObject var dataViewModel: DataViewModel
    
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @State var showImagePicker = false
    @State var userName = String()
    @State var givenAmount = String()
    @State var avatarImage = UIImage(named: "default-avatar")!
    @State var step = 0
    @State var currency: String = ""
    @State var showCustomTextAlert = false
    @State var textFieldValue: String = ""
    
    
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor(backgroundColor))
                .opacity(0.3)
                .ignoresSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: true) {
                
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
                    
                    VStack{
                        if step >= 1{
                            Button("Custom") {
                                showCustomTextAlert = true
                            }.padding(.leading, 250)
                        }
                       
                        HStack{
                            Stepper(value: $step, in: 0...dataViewModel.billsArray.count) {
                                Picker("Currency", selection: $currency) {
                                    ForEach(dataViewModel.usersCurrency, id: \.self) { i in
                                        Text(i)
                                    }
                                }
                                
                            }
                            
                        }
                        
                        ForEach(0..<step, id: \.self) { index in
                            HStack{
                                Picker(selection: $dataViewModel.valuePlacer[index], label: pickerLabel) {
                                    ForEach(dataViewModel.billsArray, id: \.self ) { value in
                                        Text(value).tag(index)}}
                                TextField("Enter Amount", text: $dataViewModel.initValue[index])
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                }
                
                .textFieldStyle(.roundedBorder)
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $avatarImage)
                }
                
                VStack{
                    Button("Save") {
                        dataViewModel.showAlert(num: step, name: userName, amount: givenAmount, firstValue: dataViewModel.initValue)
                        dataViewModel.addValueToArray()
                        dataViewModel.addInitialValue()
                        dataViewModel.steps = step
                        print(dataViewModel.showBillAlert)
                        print(dataViewModel.showAmountAlert)
                        print(dataViewModel.showMissingNameAlert)
                        print(dataViewModel.showMissingAmountAlert)
                        if !dataViewModel.showAmountAlert && !dataViewModel.showBillAlert && !dataViewModel.showMissingAmountAlert && !dataViewModel.showMissingNameAlert {
                            dataViewModel.saveInfo(name: userName, amount: givenAmount, selectImage: avatarImage, initialArray: dataViewModel.usersInfo.initialValue, valueArray: dataViewModel.usersInfo.valueHolder, steps: dataViewModel.steps, selectedCurrency: currency)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    .font(.system(size: 25))
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(15)
                    .tint(textColor)
                }
            }
            .environmentObject(dataViewModel)
            //MARK: - Alerts below
            .alert(isPresented: getAlertBinding(), content: {
                getAlert()
            })
            .alert("Enter Custom Bill", isPresented: $showCustomTextAlert) {
                TextField("Custom Bill", text: $textFieldValue)
                Button("Save") {
                    dataViewModel.billsArray.append(textFieldValue)
                    showCustomTextAlert = false
                }
            }
            //MARK: - Alerts Above
            .foregroundColor(foregroundColor)
            
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
    func getAlert() -> Alert {
        if dataViewModel.showMissingNameAlert {
            return Alert(title: Text("Missing Users Name"), message: Text("Please enter name"))
        } else if dataViewModel.showMissingAmountAlert {
            return Alert(title: Text("Missing Initial Amount"), message: Text("Please enter users initial amount"))
        } else if dataViewModel.showBillAlert {
            return Alert(title: Text("Missing Bill and Amount"), message: Text("Please press the '+' to add the type of bill and amount"))
        } else if dataViewModel.showAmountAlert {
            return Alert(title: Text("Missing Amount"), message: Text("Please enter amount value"))
        
        } else {
            return Alert(title: Text(""), message: Text(""))
        }
    }
//    func customTextAlert() -> Alert {
//      let customAlert = Alert(title: Text("Enter custom bill"), message: Text(""), primaryButton: .default(Text("Save"), action: {
//            dataViewModel.billsArray.append(textFieldValue)
//        }), secondaryButton: .cancel())
//        TextField("Enter Custom Bill", text: $textFieldValue)
//        return customAlert
//    }
    var pickerLabel: some View {
        HStack {
            Text("Custom")
            Spacer()
            Button(action: {
                for num in 0..<step{
                    if dataViewModel.valuePlacer[num] == "Custom" {
                        showCustomTextAlert = true
                    }
                }
            }) {
                Text("Button")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
struct AddUserView_Previews: PreviewProvider {
    @State private static var userInfo = UsersInfo(id: UUID(), name: "", amount: "", steps: 0)
    
    static var previews: some View {
        
        EntryView()
        
            .environmentObject(DataViewModel(usersInfo: userInfo))
        
    }
}

