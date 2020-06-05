//
//  CardView.swift
//  Flashzilla
//
//  Created by Christopher Walter on 6/3/20.
//  Copyright © 2020 Christopher Walter. All rights reserved.
//

import SwiftUI

struct CardView: View {
    // this is for accessibility for color blindness
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    // added for other accessibility features
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    let card: Card
    
    var removal: (() -> Void)? = nil
    
    @State private var isShowingAnswer = false
    
    // for the drag gesture
    @State private var offset = CGSize.zero

    // for haptic controls
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(
                differentiateWithoutColor
                    ? Color.white
                    : Color.white
                        .opacity(1 - Double(abs(offset.width / 50)))

            )
            .background(
                differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? Color.green : Color.red)
            )
            .shadow(radius: 10)

            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { offset in
                    self.offset = offset.translation
                    self.feedback.prepare()
                }
                .onEnded { _ in
                    if abs(self.offset.width) > 100 {
                        // remove the card
                        if self.offset.width > 0 {
                            self.feedback.notificationOccurred(.success)
                        } else {
                            self.feedback.notificationOccurred(.error)
                        }

                        self.removal?()
                    } else {
                        self.offset = .zero
                    }
                }
        )
        .onTapGesture {
            self.isShowingAnswer.toggle()
        }
        .animation(.spring())
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
