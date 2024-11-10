//
//  Transcription.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 10/11/2024.
//

import Foundation

@MainActor private var allTranscriptions : [String:[SubTranscription]]? = nil

@MainActor
func prepareTranscription(_ callId:String) -> Transcription? {
    guard let allTranscriptions else {
        return nil
    }
    guard let c = allTranscriptions[callId] else {
        return Transcription(content: [])
    }
    return Transcription(content: c)
}


struct Transcription {
    let content : [SubTranscription]
}

struct SubTranscription : Hashable {
    let decoratedTexts : [DecoratedTranscription]
    let mine : Bool
        
}

struct DecoratedTranscription : Hashable {
    let position : Position
    let foreach_id : Int
    let text : String
    
}

enum Position {
    case first, mid, last, alone
}


//MARK: - internal json decoding

fileprivate struct TranscriptionResponse: Decodable {
    let transcription: [TranscriptionJS]
}

fileprivate struct TranscriptionJS: Decodable {
    let uuid: String
    let callUuid: String
    let direction: DirectionJS
    let text: String
}

fileprivate enum DirectionJS: Int, Decodable {
    case outgoing = 0
    case incoming = 1
}

@MainActor func loadTranscriptions() {
    
    guard allTranscriptions==nil else {
        return
    }
    allTranscriptions = [:]
    
    Task(priority: .userInitiated) {
        
        let jsonPath = Bundle.main.path(forResource: "transcriptions", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
        let decoder = JSONDecoder()
        let infos = try! decoder.decode(TranscriptionResponse.self, from: data)
        
        var dict : [String:[SubTranscription]] = [:]
        
        var partialTranscriptions : [SubTranscription] = []
        var partialSubTranscriptions : [DecoratedTranscription] = []
        
        var lastCallId = ""
        var lastText = ""
        var lastDirection = DirectionJS.outgoing
        
        var currentId = 0
        
        let endSubTranscription = {
            let pos = partialSubTranscriptions.isEmpty ? Position.alone : Position.last
            partialSubTranscriptions.append(DecoratedTranscription(position: pos, foreach_id: currentId, text: lastText))

            let st = SubTranscription(decoratedTexts: partialSubTranscriptions, mine: lastDirection == .outgoing)
            partialTranscriptions.append(st)
            partialSubTranscriptions.removeAll()
        };

        let endTranscription = {
            endSubTranscription()
            
            dict[lastCallId] = partialTranscriptions
            partialTranscriptions.removeAll()
            
            currentId = 0
        }
        
        for call in infos.transcription {
            if call.callUuid == lastCallId {
                if call.direction == lastDirection {
                    let position = partialSubTranscriptions.isEmpty ? Position.first : Position.mid
                    partialSubTranscriptions.append(DecoratedTranscription(position: position, foreach_id: currentId, text: lastText))
                } else {
                    endSubTranscription()
                    
                    lastDirection = call.direction
                }
            } else {
                endTranscription()
                
                lastCallId = call.callUuid
            }
            
            lastText = call.text
            currentId += 1
        }
        
        endTranscription()
        
        DispatchQueue.main.async {
            allTranscriptions = dict
            
            /*
            //track missing call
            let tr = dict.keys
            var calls = allCalls.calls.filter { !$0.failed }
            print("\(tr.count) vs \(calls.count)")
            
            calls.removeAll { c in
                tr.contains { s in s == c.id }
            }
            print("alone \(calls)")
            */
        }
        
    }
    
}
