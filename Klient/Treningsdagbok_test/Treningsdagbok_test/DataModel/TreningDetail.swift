//
//  TreningDetail.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 02/01/2022.
//

import Foundation
import AppKit

struct TreningDetail: Codable {
    var id: Int
    var dato: String
    var overskrift: String
    var kommentar: String
    var rpe: Int
    var dagsform: Int
    var hoyde: Int
    
    var intervall: Bool
    
    var former: [Form]
    
    var skade: Bool
    var skadeKommentar: String = ""
    
    var konkurranse: Bool
    var konk_tid: String = ""
    var konk_fornoyd: Int = 0
    
    var standardokt: Bool
    var st_navn: String
    var st_runder: [Runde]
    var st_alle_typer: [String]
}

struct Runde: Hashable, Codable {
    var nr: Int
    var tid: String
    var avg_HRM: Int
    var max_HRM: Int
}
                    

struct Form: Hashable, Codable {
    var tid: Int
    var dist: Float
    var type: String
}
