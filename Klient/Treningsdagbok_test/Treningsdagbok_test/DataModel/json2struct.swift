//
//  json2struct.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 01/01/2022.
//

import Foundation

var uke: [OversiktDag] = load("test_uke.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("ups!")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Ups!")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldnt parse \(filename) as \(T.self):\n\(error)")
    }
}


