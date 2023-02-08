//
//  StartAtView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/30/23.
//

import SwiftUI

struct StartAtView: View {
    
    @State private var startDate = Date()
    
    private var nowDate: Date {
        return Date()
    }
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .padding()
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Label {
                        Text("Start \(startDate.time(relativeTo: nowDate))")
                    } icon: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.green)
                    }.bold()
                    Spacer()
                }
                .padding()
                .buttonStyle(.plain)
                .background(.thinMaterial)
                .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}

struct DatePlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        StartAtView()
    }
}
