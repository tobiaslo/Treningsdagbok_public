//
//  OversiktDag.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 01/01/2022.
//

import Foundation

struct Uke: Codable, Hashable {
    var aar: Int
    var nr: Int
    var tot_dist: Float
    var tot_tid: String
    var tot_ant: Int
    var pie_labels: [String]
    var pie_data: [Int]
    var dager: [OversiktDag]
}

struct OversiktDag: Codable, Hashable {
    var dato: String
    var treninger: [OversiktTrening]
}

struct OversiktTrening: Codable, Hashable {
    var id: Int
    var nr: Int
    var overskrift: String
    var tid: Int
    var dist: Float
    var rpe: Int
}
