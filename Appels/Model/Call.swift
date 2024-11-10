//
//  Call.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 09/11/2024.
//

import Foundation



@MainActor let allCalls = Model()

struct Call {
    let id: String
    let phoneNumber: String
    let startedAt: String
    let failed: Bool
    let incoming: Bool

    fileprivate init(_ calljs: CallJS) {
        phoneNumber = Self.formatedPhoneNumber(calljs.phoneNumber)
        id = calljs.uuid
        startedAt = calljs.startDate.formatted(date: .abbreviated, time: .shortened)
        failed = calljs.status != .success
        incoming = calljs.direction == .incoming
    }

    fileprivate static func formatedPhoneNumber(_ phone : String) -> String {
        let pattern = [3, 1, 2, 2, 2, 2]
        
        var currentPatternIndex = 0
        var charWritten = 0
        var formated = ""
        for c in phone {
            formated += c.description
            charWritten += 1
            if charWritten == pattern[currentPatternIndex] {
                currentPatternIndex += 1
                charWritten = 0
                formated += " "
            }
        }
        return formated
    }

}


@MainActor
class Model: ObservableObject {
    var calls: [Call] = []
    @Published var callsChanged = false
    private var worker : Task<Void, Never>? = nil
    
    static func loadAll(withDelay: Bool = false) {

        allCalls.worker = Task(priority: .userInitiated) {
            
            let jsonPath = Bundle.main.path(forResource: "calls", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            let infos = try! decoder.decode(CallResponse.self, from: data)

            let calls = infos.call.sorted { $0.startDate < $1.startDate }

            for call in calls {
                if Task.isCancelled {
                    return
                }
                
                allCalls.calls.insert(Call(call), at: 0)
                allCalls.callsChanged = true
                
                if withDelay {
//                    DispatchQueue.main.async {
//                        print("loading : \(allCalls.calls.count)")
//                    }
                    try? await Task.sleep(nanoseconds: 1_000_000 * 5)
                }
            }
            
            allCalls.worker = nil
        }
    }

    static func clean() {
        
        if let worker = allCalls.worker {
            worker.cancel()
        }
                
        allCalls.calls.removeAll()
        allCalls.callsChanged = true
    }
}

//MARK: internal json decoding

fileprivate struct CallResponse: Decodable {
    let call: [CallJS]
}

fileprivate struct CallJS: Decodable {
    let uuid: String
    let phoneNumber: String
    let startDate: Date
    let endDate: Date?
    let status: CallStatusJS
    let direction: DirectionJS
}

fileprivate enum DirectionJS: Int, Decodable {
    case outgoing = 0
    case incoming = 1
}

fileprivate enum CallStatusJS: Int, Decodable {
    case success = 0
    case missed
    case rejected
    case not_reached
}
