//
//  SettingsView.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/29/23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage ("backgroundColor") private var backgroundColor = AppColors.appColorGray
    @AppStorage ("textColor") private var textColor = AppColors.appColorYellow
   @AppStorage ("secTextColor") private var secTextColor = AppColors.appColorBlue
    
    
    var body: some View {
        NavigationView {
            ZStack {
               
                VStack{
                   
                    Form {
                        ColorPicker("Background Color", selection: $backgroundColor)
                            .listRowBackground(backgroundColor)
                            
                            .padding()
                    }
                    
                }
            
            }
                .navigationTitle("Settings")
           
                
            
        }
       
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
