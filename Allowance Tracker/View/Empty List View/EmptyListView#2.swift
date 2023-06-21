//
//  EmptyListView#2.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 6/15/23.
//

import SwiftUI

struct EmptyListView_2: View {
    
    let squarePencil = Image(systemName: "square.and.pencil")
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("Add Bills / Rewards")
            Text("Tap \(squarePencil)")
        }
        .font(.system(size: 30, weight: .medium, design: .serif))
        
        .foregroundColor(Color.white)
        .opacity(0.2)
       
    }
}

struct EmptyListView_2_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView_2()
            .background(Color.gray)
    }
        
}
