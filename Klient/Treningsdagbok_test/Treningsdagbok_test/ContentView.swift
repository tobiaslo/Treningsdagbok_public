//
//  ContentView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 01/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewController = ViewController()
    @StateObject var oversiktUke = OversiktUke()
    
    var body: some View {
        if viewController.treningsID == -1 && viewController.statistikk == -1 {
            return AnyView(UkeView(viewController: viewController, oversiktUke: oversiktUke))
        } else if viewController.treningsID == -1 && viewController.statistikk == 1 {
            return AnyView(StatstikkView(viewController: viewController, data: [StatistikkData(data: [], labels: [], fraUke: 0, fraAar: 0, tilUke: 0, tilAar: 0, statTyper: [], spesifikkTyper: [], name: "test")]))
        } else {
            return AnyView(TreningDetailView(viewController: viewController, oversiktUke: oversiktUke))
        }
           
            /*
            if (viewController.treningsID == -1 && viewController.statistikk == -1) {
                UkeView(viewController: viewController, oversiktUke: oversiktUke)
            } else if viewController.treningsID == -1 && viewController.statistikk == 0 {
                StatstikkView(viewController: viewController)
            } else {
                TreningDetailView(viewController: viewController, oversiktUke: oversiktUke)
            }
             */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
