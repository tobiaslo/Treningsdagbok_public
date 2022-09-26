//
//  StatistikkData.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 13/02/2022.
//

import Foundation

struct DataPunkt: Codable, Hashable {
    var uke: Int
    var data: Float
}

struct StatistikkData: Codable {
    var data: [DataPunkt]
    var labels: [String]
    var fraUke: Int
    var fraAar: Int
    var tilUke: Int
    var tilAar: Int
    var statTyper: [String]
    var spesifikkTyper: [String]
    var name: String
    
}
