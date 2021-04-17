//
//  ShakeDetection.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 16/04/21.
//

import Foundation
import CoreMotion

protocol ShakeDelegate{
    func receiveShakeSignal()
}

class ShakeDetection{
    
    private var motionManager = CMMotionManager()
    private var delegate: ShakeDelegate?
    
    init(delegate: ShakeDelegate){
        self.delegate = delegate
    }
    
    public func start(){
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.accelerometerUpdateInterval = 1.0/60.0
        motionManager.showsDeviceMovementDisplay = true
        
        motionManager.startAccelerometerUpdates(to: .main) { (deviceMotion, error) in
            self.accelerationHandler(deviceMotion)
        }
    }
    
    public func stop(){
        motionManager.stopAccelerometerUpdates()
    }
    
    public func accelerationHandler(_ deviceMotion: CMAccelerometerData?) {
        if let data = deviceMotion {
            if(data.acceleration.x > 1.1 || data.acceleration.y > 1.1 || data.acceleration.z > 0.8){
                self.delegate?.receiveShakeSignal()
            }
        }
        
    }
}


