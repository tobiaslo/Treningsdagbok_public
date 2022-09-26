//
//  TreningDetailView.swift
//  Treningsdagbok_test
//
//  Created by Tobias Lømo on 02/01/2022.
//

import SwiftUI

struct TreningDetailView: View {
    
    @State var trening: TreningDetail = TreningDetail(id: 0, dato: "", overskrift: "", kommentar: "", rpe: 0, dagsform: 0, hoyde: 0, intervall: false, former: [], skade: false, konkurranse: false, standardokt: false, st_navn: "", st_runder: [], st_alle_typer: [])
    @State var former: [Form] = []
    @State var runder: [Runde] = []
    
    @State var hover = -1
    
    @StateObject var viewController: ViewController
    @StateObject var oversiktUke: OversiktUke
    
    var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Overskrift", text: $trening.overskrift)
                    .font(.title)
                
                HStack {
                    Toggle("Intervall", isOn: $trening.intervall)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    
                    if (trening.standardokt == false) {
                        Toggle("Konkurranse", isOn: $trening.konkurranse)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                    }
                    
                    if (trening.konkurranse == false) {
                        Toggle("Standardøkt", isOn: $trening.standardokt)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                    }
                }
                
                if (trening.standardokt == true) {
                    HStack {
                        Text("Type:")
                        DropDownMeny(val: $trening.st_navn, placeholder: "Velg type", dropDownList: trening.st_alle_typer)
                            .frame(width: 250)
                    }
                }
                
                HStack {
                    VStack {
                        Text("")
                        Text("Tid")
                        Text("Distanse")
                    }
                    
                    ForEach(former.indices, id: \.self) { index in
                        VStack {
                            Text(former[index].type)
                                
                            
                            TextField("tid", value: $former[index].tid, formatter: NumberFormatter())
                                .multilineTextAlignment(.center)
                            TextField("dist", value: $former[index].dist, formatter: decimalFormatter)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                if (trening.standardokt) {
                    HStack {
                        VStack {
                            Text("Runde")
                            Text("Tid")
                            Text("Avg HRM")
                            Text("Max HRM")
                        }
                        
                        ForEach(runder.indices, id: \.self) { index in
                            VStack {
                                Text(self.hover == index ? "-" : String(index + 1))
                                    .foregroundColor(self.hover == index ? .red : .white)
                                    .font(self.hover == index ? .title3 : .body)
                                    .onHover { isHover in
                                        if isHover {
                                            self.hover = index
                                        } else {
                                            self.hover = -1
                                        }
                                    }
                                
                                TextField("HH:MM:SS", text: $runder[index].tid)
                                TextField("Avg HRM", value: $runder[index].avg_HRM, formatter: NumberFormatter())
                                TextField("Max HRM", value: $runder[index].max_HRM, formatter: NumberFormatter())
                            }
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(self.hover == index ? .red : .white, lineWidth: self.hover == index ? 1 : 0))
                        }
                        
                        Text("+")
                            .font(.title2)
                            .frame(maxHeight: .infinity, alignment: .center)
                            .foregroundColor(.gray)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                runder.append(Runde(nr: 0, tid: "", avg_HRM: 0, max_HRM: 0))
                            }
                    }
                }
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Stigning")
                        TextField("", value: $trening.hoyde, formatter: NumberFormatter())
                            .frame(width: 50)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Dagsform")
                        TextField("", value: $trening.dagsform, formatter: NumberFormatter())
                            .frame(width: 50)
                            .multilineTextAlignment(.center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Opplevd anstrengelse")
                        TextField("", value: $trening.rpe, formatter: NumberFormatter())
                            .frame(width: 50)
                            .multilineTextAlignment(.center)
                            .foregroundColor(getZoneColor(z: trening.rpe))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    if (trening.konkurranse) {
                        HStack {
                            Text("Fornøyd")
                            TextField("", value: $trening.konk_fornoyd, formatter: NumberFormatter())
                                .frame(width: 50)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                
                    
                TextEditor(text: $trening.kommentar)
                
                
                Toggle("Skade", isOn: $trening.skade)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                
                if (trening.skade) {
                    TextEditor(text: $trening.skadeKommentar)
                }
                
                Group {
                    Button(action: {
                        trening.former = former
                        trening.st_runder = runder
                        postData(urlString: "http://127.0.0.1:8000/post", data: trening) { u in
                            self.oversiktUke.uke = u
                        }
                        viewController.treningsID = -1
                    }) {
                        Text("Lagre")
                    }
                    
                    Button(action: {
                        deleteTrening(id: viewController.treningsID, dato: trening.dato) { u in
                            self.oversiktUke.uke = u
                        }
                        viewController.treningsID = -1
                        
                    }) {
                        Text("Slett")
                    }
                }
                
            }
            .onAppear {
                getTrening(id: viewController.treningsID, dato: viewController.dato) { t in
                    self.trening = t
                    self.former = t.former
                    self.runder = t.st_runder
                }
            }
        }
        .padding()
    }
}

struct TreningDetailView_Previews: PreviewProvider {
    static let f1 = Form(tid: 30, dist: 0.2, type: "løp")
    static let f2 = Form(tid: 10, dist: 3.5, type: "gå")
    static let r1 = Runde(nr: 1, tid: "00:50:20", avg_HRM: 100, max_HRM: 130)
    static let r2 = Runde(nr: 2, tid: "00:10:10", avg_HRM: 30, max_HRM: 100)
    static var t = TreningDetail(id: 1, dato: "", overskrift: "Test 1", kommentar: "blablabal", rpe: 6, dagsform: 4, hoyde: 50, intervall: false, former: [f1, f2], skade: true, konkurranse: false, standardokt: true, st_navn: "", st_runder: [r1, r2], st_alle_typer: ["test1", "test2", "test3"])
    
    static var previews: some View {
        TreningDetailView(trening: t, former: [f1, f2], viewController: ViewController(), oversiktUke: OversiktUke())
    }
}
