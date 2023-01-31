//
//  JobItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct JobItem: View {
    
    @StateObject var viewModel: ViewModel
    
    private var clockInNowBtn: some View {
        Button {
            withAnimation {
                viewModel.clockIn()
            }
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Clock In")
                } icon: {
                    Image(systemName: "play.fill")
                        .foregroundColor(.green)
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var clockOutNowBtn: some View {
        Button {
            withAnimation {
                viewModel.clockOut()
            }
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Clock Out")
                } icon: {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var startAtBtn: some View {
        Button {
            viewModel.showStartAtView.toggle()
        } label: {
            HStack {
                Spacer()
                Label("Start At", systemImage: "clock.fill")
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var stopAtBtn: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Label {
                    Text("Stop At")
                } icon: {
                    Image(systemName: "clock.fill")
                }
                Spacer()
            }
            .padding()
            .buttonStyle(.plain)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
    
    private var addEntryBtn: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Label("Add Entry", systemImage: "plus")
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    
    private var detailsBtn: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Label("Details", systemImage: "info.circle.fill")
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    
    private var actions: some View {
        VStack {
            HStack {
                if viewModel.clockedIn {
                    clockOutNowBtn
                    
                    stopAtBtn
                } else {
                    clockInNowBtn
                    
                    startAtBtn
                }
            }
            
            HStack {
                addEntryBtn
                
                detailsBtn
            }
        }
        .frame(height: viewModel.isDisclosed ? nil : 0, alignment: .top)
        .animation(.default, value: viewModel.isDisclosed)
    }
    
    private var content: some View {
        VStack {
            HStack {
                Text(viewModel.job.name ?? "")
                    .foregroundColor(.primary)
                Spacer()
                Button {
                    print("Details")
                } label: {
                    Image(systemName: "info.circle.fill")
                }
                .foregroundColor(.accentColor)
            }
            .contentShape(Rectangle())
            
            if viewModel.isDisclosed {
                actions
            }
        }
    }
    
    var body: some View {
        Button {
            viewModel.isDisclosed.toggle()
        } label: {
            content
        }
        .buttonStyle(.plain)
        .popover(isPresented: $viewModel.showStartAtView) {
            NavigationStack {
                StartAtView()
                    .navigationTitle(viewModel.job.name ?? "")
            }
        }
    }
}

struct JobItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
//                JobItem(job: "ICOFT")
//                JobItem(name: "SCR Database")
            }
            .navigationTitle("Job")
        }
    }
}
