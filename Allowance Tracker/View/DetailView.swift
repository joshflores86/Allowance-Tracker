//
//  DetailView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI

struct DetailView: View {
    
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var usersInfo: UserModel
    @State var name: String
    @State var avatarImage: UIImage
    @State var amount: String
    @State var id: UUID
    @State var currency = ""
    @State var steps: Int
    @State var hideSaveButton = Bool()
    
    
    
    var body: some View {
        
        ZStack{
            VStack{
                Text(name)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                HStack{
                    Spacer()
                    if !hideSaveButton {
                    Text("$\(amount)")
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .frame(alignment: .centerLastTextBaseline)
                        .padding(.bottom)
                        .padding(.trailing, 5)
                    Button("Final Payment", action: {
                            dataViewModel.addFinalPayment(
                                index:dataViewModel.usersInfoArray.firstIndex(
                                    where: { $0.id == self.id })!)
                            print(hideSaveButton)})
                        .font(.system(size: 11))
                        .buttonStyle(.borderless)
                        .padding(10)
                        .background(Color(rawValue: textColor.rawValue))
                        .cornerRadius(25)
                        .foregroundColor(Color(rawValue: foregroundColor.rawValue))
                    }else{
                        Text("$\(amount)")
                            .frame(maxWidth: .infinity, maxHeight: 35, alignment: .center)
                            .font(.system(size: 35, weight: .bold, design: .monospaced))
                            .padding(.bottom)}
                }
                .padding(.trailing, 15)
                List{
                    if let specificUser = dataViewModel.usersInfoArray.first(where: { $0.id == self.id }){
                        if specificUser.steps != 0 {
                            ForEach(0..<specificUser.steps) { num in
                                HStack{
                                    VStack{
                                        Text(specificUser.initialValue[num])
                                            .font(.system(size: 10))
                                        Text(specificUser.secondValue[num])
                                    }
                                    Spacer()
                                    Text("$\(specificUser.valueHolder[num])")
                                }
                                .listStyle(.plain)
                                .font(.system(size: 20, weight: .medium, design: .monospaced))
                            }
                        }
                    }
                }
                .onChange(of: dataViewModel.hideButton) { _ in
                    dataViewModel.saveUpdateUserAmount(index: dataViewModel.usersInfoArray.firstIndex(
                                                    where: { $0.id == self.id })!)
                }
                .onChange(of: dataViewModel.usersInfoArray) { _ in
                    try? dataViewModel.load()
                }
                .onAppear{print(dataViewModel.usersInfoArray)}
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination:
                                            EditView(viewModel:
                                                        dataViewModel, name: $name,
                                                     amount: $amount, avatarImage: $avatarImage,
                                                     id: id, steps: steps)) {
                                Image(systemName: "slider.horizontal.3")
                        }
                    }
                }
            }
            .background(Color.init(rawValue: backgroundColor.rawValue)?.ignoresSafeArea())
        }
    }
}




struct DetailView_Previews: PreviewProvider {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private static var userInfo = UserModel(id: UUID(), name: "", amount: "",
                                                   valueHolder: [], steps: 0)
    static var previews: some View {
        DetailView(usersInfo: userInfo, name: userInfo.name,
                   avatarImage: userInfo.avatarImage,
                   amount: userInfo.amount, id: userInfo.id, steps: userInfo.steps)
        .environmentObject(DataViewModel(usersInfo: UserModel(id: UUID(), name: "", amount: "",
                                                      valueHolder: [], steps: 0)))
    }
}

