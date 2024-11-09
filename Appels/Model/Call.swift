//
//  Call.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 09/11/2024.
//

import Foundation



let allCalls = Model()

class Model : ObservableObject {
    @Published var calls : [Call] = []
    
    static func loadAll() {
        
        //TODO background thread
        
        let jsonPath = Bundle.main.path(forResource: "calls", ofType: "json")!
        let data = try! Data(contentsOf:URL(fileURLWithPath: jsonPath))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let infos = try! decoder.decode(CallResponse.self, from: data)
                
        print("load \(infos.call.count) calls")
        
        allCalls.calls = infos.call
    }
    
    static func clean() {
        allCalls.calls.removeAll()

        print("clean : \(allCalls.calls.count)")

    }
}


struct CallResponse : Decodable {
    let call : [Call]
}

struct Call : Decodable {
    let uuid: String
    let phoneNumber: String
    let startDate: Date
    let endDate: Date?
    let status: CallStatus
    let direction: Direction
}


enum Direction : Int, Decodable {
    case outgoing = 0
    case incoming = 1
}


enum CallStatus : Int, Decodable {
    case success = 0
    case missed
    case rejected
    case not_reached
}

