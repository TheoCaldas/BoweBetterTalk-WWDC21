//
//  TimeCounter.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import Foundation

class TimeCounter{
    private var timeStep: TimeInterval = 0.02
    private var totalTime: TimeInterval = .zero
    
    private var internalTimer: Timer?
    
    public func start(){
        guard self.internalTimer == nil else { return }
        self.internalTimer = Timer.scheduledTimer(timeInterval: self.timeStep, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime(){
        self.totalTime += self.timeStep
    }
    
    public func stop(){
        self.internalTimer?.invalidate()
        self.internalTimer = nil
    }
    
    public func reset(){
        self.totalTime = .zero
    }
    
    public func getTime() -> TimeInterval{
        return self.totalTime
    }
}
