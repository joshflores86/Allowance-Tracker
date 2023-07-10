//
//  MainView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI


struct MainView: View {
    
  
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var isDetailViewPresented = false
    @AppStorage ("foregroundColor") private var foregroundColor = AppColors.appColorYellow
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorBlue
    //    @Environment(\ColorScheme, .dark)
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(uiColor: UIColor(backgroundColor))
                    .opacity(0.3)
                    .ignoresSafeArea()
                VStack{
                    if $dataViewModel.usersInfoArray.isEmpty  {
                        EmptyListView()
                    }else {
                        VStack{
                            Text("Allowance Tracker")
                                .font(Font.custom("Lobster-Regular", size: 50))
                                .frame(width: .infinity, height: 50, alignment: .leading)
                            VStack{
                                List {
                                    ForEach(dataViewModel.usersInfoArray.indices, id: \.self) { index in
                                        let users = dataViewModel.usersInfoArray[index]
                                        let amountWrapper = BindingWrapper(value: users.amount)
                                        NavigationLink(
                                            destination:DetailView(
                                                dataViewModel: _dataViewModel,
                                                usersInfo: users,
                                                name: users.name,
                                                avatarImage: users.avatarImage,
                                                amount: amountWrapper.binding,
                                                id: users.id,
                                                steps: users.steps,
                                                hideSaveButton: users.showNoButton,
                                                firstValue: users.initialValue,
                                                secondValue: users.secondValue,
                                                mainValue: users.valueHolder)) {
                                            HStack{
                                                Image(uiImage: (users.avatarImage ?? UIImage(systemName: "default-avatar"))!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                                Text(users.name)
                                                    .padding(.horizontal)
                                                Text("$\(users.amount)")
                                            }
                                            
                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                        }
                                    }
                                    .onDelete(perform: dataViewModel.deleteUsers)
                                }
                                .onChange(of: dataViewModel.usersInfoArray, perform: { _ in
                                    try! dataViewModel.save()
                                    try? dataViewModel.load()
                                    
                                })
                            }
                        }
                    }
                }
            }
            .environmentObject(dataViewModel)
            .fixedSize(horizontal: false, vertical: false)
            .onAppear{
                try? dataViewModel.load()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EntryView(dataViewModel: dataViewModel)) {
                        Text(Image(systemName: "plus"))
                            .foregroundColor(textColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Text(Image(systemName: "gear"))
                            .foregroundColor(textColor)
                    }
                }
            }
        }
        .foregroundColor(foregroundColor)
    }
}

extension Data {
    var uiImage: UIImage? {
        guard let image = UIImage(data: self) else {
            return nil
        }
        return image
    }
}


struct MainView_Previews: PreviewProvider {
    
    @State private static var userInfo = UserModel(id: UUID(),
                                                   name: "",
                                                   amount: "",
                                                   initialValue: [],
                                                   valueHolder: [ ],
                                                   steps: 0)
    
    static var previews: some View {
        let dataViewModel = DataViewModel(usersInfo: userInfo)
        
        return MainView()
            .environmentObject(DataViewModel(usersInfo: userInfo))
    }
}
