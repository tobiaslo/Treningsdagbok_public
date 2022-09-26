//
//  StateObjects.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 05/01/2022.
//

import Foundation


class ViewController: ObservableObject {
    @Published var treningsID = -1
    @Published var statistikk = -1
    @Published var dato: String = ""
}

class OversiktUke: ObservableObject {
    @Published var uke: Uke = Uke(aar: 0, nr: 0, tot_dist: 0.0, tot_tid: "0:0", tot_ant: 0, pie_labels: ["test1", "test2"], pie_data: [30, 10], dager: [])
    
    init() {
        getUke(aar: 0, nr: 0) { u in
            self.uke = u
        }
    }
    
    func nesteUke() {
        getNesteUke(aar: uke.aar, nr: uke.nr) { u in
            self.uke = u
        }
    }
    
    func forrigeUke() {
        getForrigeUke(aar: uke.aar, nr: uke.nr) { u in
            self.uke = u
        }
    }
    
    func testUke() {
        self.uke = Uke(aar: 2022, nr: 3, tot_dist: 30.5, tot_tid: "3:05", tot_ant: 5, pie_labels: ["test1", "test2"], pie_data: [30, 10], dager: [])
    }
}
