//
//  APIConnection.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 03/01/2022.
//

import Foundation


func getUke(aar: Int, nr: Int, completion: @escaping (Uke) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/oversikt/uke/\(aar)/\(nr)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode(Uke.self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            print("hei!!")
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

func getNesteUke(aar: Int, nr: Int, completion: @escaping (Uke) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/oversikt/uke/neste/\(aar)/\(nr)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode(Uke.self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

func getForrigeUke(aar: Int, nr: Int, completion: @escaping (Uke) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/oversikt/uke/forrige/\(aar)/\(nr)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode(Uke.self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

func getTrening(id: Int, dato: String, completion: @escaping (TreningDetail) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/trening/\(id)?dato=\(dato)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode(TreningDetail.self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

func deleteTrening(id: Int, dato: String, completion: @escaping (Uke) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/fjern/\(id)?dato=\(dato)") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode(Uke.self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

func postData(urlString: String, data: TreningDetail, completion: @escaping (Uke) -> ()) {
    
    guard let uploadData = try? JSONEncoder().encode(data) else {
        print("Cant encode object")
        return
    }

    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.uploadTask(with: request, from: uploadData) {data, response, error in
        if let error = error {
            fatalError("Error: \(error)")
        }
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            fatalError("Server error")
        }
        
        if let mimeType = response.mimeType,
           mimeType == "application/json",
           let data = data {
            do {
                let posts = try JSONDecoder().decode(Uke.self, from: data)
                DispatchQueue.main.async {
                    completion(posts)
                }
            } catch {
                fatalError("Coudnt parse json")
            }
            
        }

    }
    task.resume()
}

func getStatistikk(fraUke: Int, fraAar: Int, tilUke: Int, tilAar: Int, statType: Int, completion: @escaping ([StatistikkData]) -> Void) {
    print(statType)
    
    guard let url = URL(string: "http://127.0.0.1:8000/statistikk?fraUke=\(fraUke)&fraAar=\(fraAar)&tilUke=\(tilUke)&tilAar=\(tilAar)&statType=\(statType)") else { return }
    
    //guard let url = URL(string: "http://127.0.0.1:8000/statistikk") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            if let error = error {
                let _ = print("ups \(error)")
                return
            }
            
            return
        }
        
        do {
            let posts = try JSONDecoder().decode([StatistikkData].self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        } catch {
            print("hei!!")
            fatalError("Coudnt parse json")
        }
        
    }
    task.resume()
}

