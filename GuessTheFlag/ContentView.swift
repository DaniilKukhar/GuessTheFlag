//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Danya Kukhar on 07.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var scoreAmount = 0
    @State private var currentChoose = 0
    @State private var gameIsOver = false
    @State private var roundOfGame = 0 {
        willSet {
            if newValue == 8 {
                gameIsOver = true
            }
        }
    }
    
    @State var countries = ["Estonia", "France",
                     "Germany", "Ireland",
                     "Italy", "Monaco",
                     "Nigeria", "Poland",
                     "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.6), location: 0.3),
                Gradient.Stop(color: Color(red: 0.75, green: 0.15, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            currentChoose = number
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreAmount)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            .alert("Game is Over", isPresented: $gameIsOver) {
                Button("Restart game", action: reset)
            } message: {
                Text("Your score is \(scoreAmount)")
                
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle.hasPrefix("Correct"){
                Text("You are score is \(scoreAmount)")
            } else {
                Text("Wrong! That’s the flag of \(countries[currentChoose])")
            }
        }
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingScore = false
        scoreAmount = 0
        gameIsOver = false
        roundOfGame = 0
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreAmount += 1
        } else if number != correctAnswer && scoreAmount > 0 {
            scoreTitle = "Wrong"
            scoreAmount -= 1
        } else {
            scoreAmount = 0
        }
        showingScore = true
        roundOfGame += 1
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
