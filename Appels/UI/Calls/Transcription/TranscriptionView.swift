//
//  TranscriptionView.swift
//  Appels
//
//  Created by Pascal Costa-Cunha on 10/11/2024.
//

import SwiftUI


struct TranscriptionView: View {
        
    let transcription: Transcription
    
    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack(alignment: .center, spacing: 24) {
                Spacer().frame(height: 0)
                
                Text("chat_advert")
                    .myPadding()
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12))
                    .foregroundStyle(Colors.Transcription.advert)
                    .background(Colors.Transcription.advertBackground)
                    .cornerRadius(12)
                
                
                VStack(alignment: .leading) {
                    ForEach(transcription.content, id: \.self ) { subTranscription in
                        HStack() {
                            if subTranscription.mine {
                                userText(subTranscription)
                                Spacer()
                                
                            } else {
                                Spacer()
                                userText(subTranscription)
                            }
                        }
                    }
                }.padding(.horizontal, 29)
            }

            Spacer(minLength: 25)

        }.frame(maxWidth: .infinity).background(.white)
    }
}


extension TranscriptionView {
        
    func userText(_ st : SubTranscription) -> some View {
        VStack(alignment: st.mine ? .leading : .trailing, spacing: 4) {
            ForEach(st.decoratedTexts, id: \.self) { dt in
                Text(dt.text).config(dt.position, isMine:st.mine)
            }
        }
    }
    
}


//MARK: - rounded label

private struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//MARK: - helpers

private func corners(_ pos : Position, isMine:Bool) -> UIRectCorner {
    if isMine {
        switch pos {
        case .first: [.topRight, .topLeft, .bottomRight]
        case .last: [.topRight, .bottomRight, .bottomLeft]
        case .mid: [.topRight, .bottomRight]
        case .alone: .allCorners
        }
    } else {
        switch pos {
        case .first: [.topRight, .topLeft, .bottomLeft]
        case .last: [.topLeft, .bottomRight, .bottomLeft]
        case .mid: [.topLeft, .bottomLeft]
        case .alone: .allCorners
        }
    }
}


private extension Text {
        
    func myPadding() -> some View {
        self.padding(.horizontal, 15)
            .padding(.vertical, 10)
    }
    
    func config(_ pos : Position, isMine mine: Bool) -> some View {
        
        let shape = RoundedCorner(radius: 20, corners: corners(pos, isMine: mine))
        
        return self.myPadding()
            .background(mine ? .white : Colors.Transcription.otherBackground )
            .foregroundStyle(mine ? Colors.Transcription.mineText : Colors.Transcription.otherText)
            .clipShape( shape )
            .overlay {
                shape.stroke(Colors.Transcription.mineBorder, lineWidth: mine ? 2 : 0)
            }
    }
}


#Preview {
    let currentTranscription = Transcription(content: [
        /*
        SubTranscription(decoratedTexts: [
            DecoratedTranscription(position: .first, foreach_id: 0, text: "Je souhaiterais prendre rendez-vous mardi prochain"),
            DecoratedTranscription(position: .mid, foreach_id: 0, text:"Oui bonjour"),
            DecoratedTranscription(position: .last, foreach_id: 0, text: "Sera-t-il disponible semaine pro ?")
        ], mine: true),
        SubTranscription(decoratedTexts: [
            DecoratedTranscription(position: .first, foreach_id: 0, text: "Oui allô ?"),
            DecoratedTranscription(position: .last, foreach_id: 0, text: "Sera-t-il disponible ?")
        ], mine: false),
        SubTranscription(decoratedTexts: [
            DecoratedTranscription(position: .first, foreach_id: 0, text: "Sera-t-il disponible la semaine suivante ?"),
            DecoratedTranscription(position: .last, foreach_id: 0, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse egestas eros elementum nulla auctor gravida ac pharetra velit. Nunc porttitor eros nec lectus bibendum pulvinar. Donec cursus arcu sed purus molestie hendrerit. Vivamus fermentum in turpis in auctor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.")
        ], mine: true)
         */
    ])
    
    TranscriptionView(transcription: currentTranscription)
}
