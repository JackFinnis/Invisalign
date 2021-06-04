//
//  TimerView.swift
//  Invisalign WatchKit Extension
//
//  Created by Finnis on 04/06/2021.
//

import SwiftUI

struct TimerView: View {
    @State var accumulatedSeconds: Int = 0
    @State var newSeconds: Int = 0
    @State var counting: Bool = false
    @State var startDate: Date = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var toggleImageName: String {
        if counting {
            return "stop.fill"
        } else {
            return "play.fill"
        }
    }
    
    var body: some View {
        VStack {
            Text(elapsedTimeString(elapsed: secondsToMinutesSeconds(seconds: accumulatedSeconds + newSeconds)))
            Button(action: {
                if counting {
                    counting = false
                    accumulatedSeconds += Int(Date().timeIntervalSince(startDate))
                    newSeconds = 0
                } else {
                    counting = true
                    startDate = Date()
                }
            }, label: {
                Image(systemName: toggleImageName)
                    .foregroundColor(.accentColor)
            })
            Button(action: {
                counting = false
                accumulatedSeconds = 0
                newSeconds = 0
            }, label: {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.accentColor)
            })
        }
        .font(.largeTitle)
        .onReceive(timer) { _ in
            if counting {
                newSeconds = Int(Date().timeIntervalSince(startDate))
            }
        }
    }
    
    // Convert the seconds into seconds and minutes
    func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    // Convert the seconds, minutes, hours into a string.
    func elapsedTimeString(elapsed: (m: Int, s: Int)) -> String {
        return String(format: "%02d:%02d", elapsed.m, elapsed.s)
    }
}
