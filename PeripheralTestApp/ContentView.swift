//
//  ContentView.swift
//  iPadkeyboard
//
//  Created by Izumi Kiuchi on 2023/12/02.
//

import SwiftUI
import CoreBluetooth






struct ContentView: View {
    @State var advertiseIsOn: Bool = false
    @ObservedObject var peripheralManager = PeripheralManager()

    var body: some View {
        VStack {
            Button(action: advertise) {
                Text("Start advertise")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
            .frame(width: 250, height: 40)
            .padding(.all)
            .background(Color.blue)


            Button(action: stopAdvertise) {
                Text("Stop advertise")
                    .font(.largeTitle)
                    .foregroundColor(advertiseIsOn ? Color.white : Color.gray)
            }
            .frame(width: 250, height: 40)
            .padding(.all)
            .background(Color.blue)


            Button(action: notify) {
                Text("Notify")
                    .font(.largeTitle)
                    .foregroundColor(advertiseIsOn ? Color.white : Color.gray)
            }
            .frame(width: 250, height: 40)
            .padding(.all)
            .background(Color.blue)


            Button(action: indicate) {
                Text("Indicate")
                    .font(.largeTitle)
                    .foregroundColor(advertiseIsOn ? Color.white : Color.gray)
            }
            .frame(width: 250, height: 40)
            .padding(.all)
            .background(Color.blue)

            Text("PeripheralManagerStates")
                       .font(.title)
                       .padding(10)

            Text("\(peripheralManager.peripheralManagerState)")

        }
        .padding()
    }
    
    private func advertise(){
        advertiseIsOn = true
        self.peripheralManager.startAdvertising()
    }

    private func stopAdvertise(){
        advertiseIsOn = false
        self.peripheralManager.stopAdvertising()
    }

    private func notify(){
        self.peripheralManager.notify()
    }


    private func indicate(){
        self.peripheralManager.indicate()
    }

}

#Preview {
    ContentView()
}

