//
//  Main1.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import PlaygroundSupport
import SpriteKit
import CoreMotion

public class Main2: SKScene, ShakeDelegate, MicDelegate {
    
    private enum GameUI{
        case shake
        case mic
    }
    
    private enum PlayingState{
        case voiceOver1 //first instruction
        case shakeDetecting //game1
        case voiceOver2 //second instruction
        case blowDetecting //game2
        case finished //ok
    }
    
    private var shake: ShakeDetection?
    private var currentShakeAmount: Float = .zero
    private let shakeAmountTarget: Float = 5.0
    private var wallHits = 0
    
    private var mic: MicDetection?
    private var currentScreamAmount: Float = .zero
    private let screamAmountTarget: Float = 4.0
    
    private var playingState: PlayingState = .voiceOver1
    private var timerVoiceOver1 = TimeCounter()
    private var timerVoiceOver2 = TimeCounter()
    private var timerHint = TimeCounter()
    
    private var boweNode = SKSpriteNode()
    private var darwinNode = SKSpriteNode()
    private var wallNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var shakeNode = SKSpriteNode()
    
    private var boweIsHappy = false
    private var hint1HasAppeared = false
    private var hint2HasAppeared = false
    
    private var wallDoodle: DoodleEffect?
    private var blowDoodles = [DoodleEffect]()
    private let blowDoodlesInitialPos: [CGPoint] = [CGPoint(x: 0, y: -100), CGPoint(x: -280, y: 80), CGPoint(x: 150, y: 280), CGPoint(x: 200, y: -320)]
    private let blowDoodlesSize: [CGFloat] = [300, 200, 200, 200]
    private var doodlesBlownCount = 0
    
    private var messageParticle: Particle?
    private var messageChanged = false
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.darwinNode = self.childNode(withName: "//darwin") as! SKSpriteNode
        self.wallNode = self.childNode(withName: "//wall") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.shakeNode = self.childNode(withName: "//shake") as! SKSpriteNode
        
        self.wallDoodle = DoodleEffect(in: self.wallNode, point: CGPoint(x: 40, y: -30), width: 180, height: 930, numParticles: 4, particlesSpeed: 10, particlesRadius: 15, particlesLineWidth: 20, particlesMaxPoint: 200, fieldPos: .center, fieldStrength: 1)
        self.wallDoodle?.startParticlesMove()
        
        self.hideUI()
        self.boweIdleTalk()
        Animator.animateDarwin(node: self.darwinNode, animation: .idle, mustLoop: true){}
        SoundManager.sharedInstance().playBackgroundMusic(.minigame2, mustLoop: false)
        self.shake = ShakeDetection(delegate: self)
        self.mic = MicDetection(delegate: self, volumeThreshold: 20.0)
        self.timerVoiceOver1.start()
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        self.renderDoodles()
        self.updateProgressBar()
        self.updateBlowDoodles()
        self.updateMessageParticle()
        self.checkMessageParticle()
        if self.playingState == .voiceOver1{
            if self.timerVoiceOver1.getTime() >= 2.0 && self.timerVoiceOver1.getTime() < 3.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame3VoiceOver1, mustLoop: false)
            }else if self.timerVoiceOver1.getTime() >= 7.0{
                self.startGame1()
            }
        }
        if self.playingState == .voiceOver2{
            if self.timerVoiceOver2.getTime() >= 1.5 && self.timerVoiceOver2.getTime() < 2.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame3VoiceOver2, mustLoop: false)
            }else if self.timerVoiceOver2.getTime() >= 5.5{
                self.startGame2()
            }
        }
        if self.playingState == .shakeDetecting || self.playingState == .voiceOver2{
            self.updateWall()
        }
        if self.playingState == .shakeDetecting || self.playingState == .blowDetecting{
            if self.timerHint.getTime() >= 3.0{
                self.showHint()
            }
        }
    }
    
    func receiveShakeSignal() {
        self.currentShakeAmount += 0.1
        self.timerHint.reset()
        
        if self.currentShakeAmount >= self.shakeAmountTarget{
//            self.currentShakeAmount = .zero
            self.endGame1()
        }
    }
    
    func receiveMicSignal() {
        self.currentScreamAmount += 0.1
        self.timerHint.reset()
        
        if self.currentScreamAmount >= self.screamAmountTarget{
//            self.currentScreamAmount = .zero
            self.endGame2()
        }
    }
    
    private func startGame1(){
        self.timerVoiceOver1.stop()
        self.playingState = .shakeDetecting
        self.shake?.start()
        self.showUI(.shake)
        self.timerHint.start()
    }
    
    private func endGame1(){
        self.timerVoiceOver2.start()
        self.playingState = .voiceOver2
        self.shake?.stop()
        self.hideUI()
        self.timerHint.stop()
        self.timerHint.reset()
        Animator.animateDarwin(node: self.darwinNode, animation: .angry, mustLoop: false){}
    }
    
    private func startGame2(){
        self.timerVoiceOver2.stop()
        self.playingState = .blowDetecting
        self.mic?.settupRecorder()
        self.mic?.startRecorder()
        self.showUI(.mic)
        self.timerHint.start()
        SoundManager.sharedInstance().changeVolumeBackgroundMusic(volume: 0.1)
        SoundManager.sharedInstance().changeVolumeSFX(volume: 0.1)
    }
    
    private func endGame2(){
        self.playingState = .finished
        self.mic?.stopRecorder()
        self.hideUI()
        self.timerHint.stop()
        self.timerHint.reset()
        PlaygroundPage.current.assessmentStatus = .pass(message: "Finally! Checkout the [last page](@next)")
        Animator.animateDarwin(node: self.darwinNode, animation: .idleHappy, mustLoop: true){}
        SoundManager.sharedInstance().playSoundEffect(.nextLevel, mustLoop: false)
        SoundManager.sharedInstance().changeVolumeBackgroundMusic(volume: 1.0)
        SoundManager.sharedInstance().changeVolumeSFX(volume: 1.0)
        self.boweIsHappy = true
    }
    
    private func hideUI(){
        self.progressBarFillNode.isHidden = true
        self.progressBarNode.isHidden = true
        self.micNode.isHidden = true
        self.shakeNode.isHidden = true
    }
    
    private func showUI(_ ui: GameUI){
        if ui == .shake{
            self.shakeNode.isHidden = false
        }else{
            self.micNode.isHidden = false
        }
        self.progressBarFillNode.isHidden = false
        self.progressBarNode.isHidden = false
        self.progressBarFillNode.xScale = .zero
    }
    
    private func showHint(){
        if self.playingState == .shakeDetecting{
            if !self.hint1HasAppeared{
                self.hint1HasAppeared = true
                SoundManager.sharedInstance().playSoundEffect(.hint, mustLoop: false)
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["Shake the device to break Bowe's wall!"], solution: nil)
            }
        }else if self.playingState == .blowDetecting{
            if !self.hint2HasAppeared{
                self.hint2HasAppeared = true
                SoundManager.sharedInstance().playSoundEffect(.hint, mustLoop: false)
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["Give a strong blown close to the screen!"], solution: nil)
            }
        }
    }
    
    private func updateProgressBar(){
        if self.playingState == .shakeDetecting{
            let progress = currentShakeAmount/shakeAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }else if self.playingState == .blowDetecting{
            let progress = currentScreamAmount/screamAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }
       
    }
    
    private func updateWall(){
        let progress = currentShakeAmount/shakeAmountTarget
        if self.wallHits == 0 && progress >= 1/3{
            self.wallHits = 1
            Animator.animateWall(node: self.wallNode, animation: .hit1, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallHit, mustLoop: false)
        }else if self.wallHits == 1 && progress >= 2/3{
            self.wallHits = 2
            Animator.animateWall(node: self.wallNode, animation: .hit2, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallHit, mustLoop: false)
        }else if self.wallHits == 2 && progress >= 1{
            self.wallHits = 3
            Animator.animateWall(node: self.wallNode, animation: .falling, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallFalling, mustLoop: false)
            self.wallDoodle?.moveTo(point: CGPoint(x: (self.wallDoodle?.currentPos.x)!, y: (self.wallDoodle?.currentPos.y)! - 1000), duration: 1.0){
                self.wallDoodle?.removeAllParticles(duration: 1.0)
                self.setBlowDoodles()
            }
        }
    }
    
    private func boweIdleTalk(){
        if self.boweIsHappy{
            Animator.animateBowe(node: self.boweNode, animation: .idleHappy, mustLoop: false){
                SoundManager.sharedInstance().playSoundEffect(.messageClear, mustLoop: false)
                self.setMessageParticle()
                Animator.animateBowe(node: self.boweNode, animation: .talking, mustLoop: false){
                    self.boweIdleTalk()
                }
            }
        }else{
            Animator.animateBowe(node: self.boweNode, animation: .idle, mustLoop: false){
                SoundManager.sharedInstance().playSoundEffect(.messageClear, mustLoop: false)
                self.setMessageParticle()
                Animator.animateBowe(node: self.boweNode, animation: .talking, mustLoop: false){
                    self.boweIdleTalk()
                }
            }
        }
        
    }
    
    private func renderDoodles(){
        self.wallDoodle!.renderEffect()
        if self.playingState == .voiceOver2 || self.playingState == .blowDetecting || self.playingState == .finished{
            for doodle in self.blowDoodles{
                doodle.renderEffect()
            }
        }
    }
    
    private func setBlowDoodles(){
        for i in 0...3{
            if i == 0{
                let blowDoodle = DoodleEffect(in: self.wallNode, point: self.blowDoodlesInitialPos[i], width: self.blowDoodlesSize[i], height: self.blowDoodlesSize[i], numParticles: 4, particlesSpeed: 10, particlesRadius: 15, particlesLineWidth: 30, particlesMaxPoint: 100, fieldPos: .center, fieldStrength: 5)
                self.blowDoodles.append(blowDoodle)
                blowDoodle.startParticlesMove()
            }else{
                let blowDoodle = DoodleEffect(in: self.wallNode, point: self.blowDoodlesInitialPos[i], width: self.blowDoodlesSize[i], height: self.blowDoodlesSize[i], numParticles: 3, particlesSpeed: 10, particlesRadius: 15, particlesLineWidth: 10, particlesMaxPoint: 100, fieldPos: .center, fieldStrength: 7)
                self.blowDoodles.append(blowDoodle)
                blowDoodle.startParticlesMove()
            }
        }
    }
    
    private func updateBlowDoodles(){
        let duration: TimeInterval = 0.5
        if self.playingState == .blowDetecting || self.playingState == .finished{
            let progress = currentScreamAmount/screamAmountTarget
            if self.doodlesBlownCount == 0 && progress >= 1/4{
                self.doodlesBlownCount = 1
                let doodle = self.blowDoodles[3]
                doodle.moveTo(point: CGPoint(x: doodle.currentPos.x + 100, y: doodle.currentPos.y - 100), duration: duration){
                    doodle.removeAllParticles(duration: duration)
                }
            }else if self.doodlesBlownCount == 1 && progress >= 2/4{
                self.doodlesBlownCount = 2
                let doodle = self.blowDoodles[2]
                doodle.moveTo(point: CGPoint(x: doodle.currentPos.x + 100, y: doodle.currentPos.y + 100), duration: duration){
                    doodle.removeAllParticles(duration: duration)
                }
            }else if self.doodlesBlownCount == 2 && progress >= 3/4{
                self.doodlesBlownCount = 3
                let doodle = self.blowDoodles[1]
                doodle.moveTo(point: CGPoint(x: doodle.currentPos.x - 100, y: doodle.currentPos.y + 100), duration: duration){
                    doodle.removeAllParticles(duration: duration)
                }
            }else if self.doodlesBlownCount == 3 && progress >= 1{
                self.doodlesBlownCount = 4
                let doodle = self.blowDoodles[0]
                doodle.removeAllParticles(duration: 2*duration)
            }

        }
    }
    
    private func setMessageParticle(){
        let duration: CGFloat = 0.5
        let offset: CGFloat = 200
        self.messageChanged = false
        self.messageParticle?.stopRender(duration: 0.0)
        self.messageParticle?.removeFromParent()
        self.messageParticle = Particle(in: self, position: CGPoint(x: -520, y: -120), speed: nil, radius: 10, lineWidth: 15, maxPoints: 10)
        self.messageParticle?.zPosition = 100
        self.addChild(self.messageParticle!)
        self.messageParticle!.stopMove()
        self.messageParticle!.physicsBody = nil
        self.messageParticle!.changeLine(strokeColor: .white, lineWidth: 15, glowWidth: 0)
        let oscillation = SKAction.oscillation(amplitude: 30, timePeriod: duration, midPoint: self.messageParticle!.position)
        let move = SKAction.moveBy(x: offset, y: 0, duration: TimeInterval(duration))
        let group = SKAction.group([oscillation, move])
        self.messageParticle!.run(SKAction.repeatForever(group))
    }
    
    private func checkMessageParticle(){
        guard let message = self.messageParticle else {return}
        if playingState == .voiceOver1 || playingState == .shakeDetecting{
            if message.position.x > -70{
//                self.messageParticle = nil
//                message.removeAllActions()
//                let random = Int.random(in: -2...1)
//                let signal = (random >= 0) ? 1 : -1
                let randomX = CGFloat.random(in: 50...200)
                let randomY = CGFloat.random(in: -100...200)
                let blockMove = SKAction.moveBy(x: -randomX, y: randomY, duration: 0.1)
                message.run(blockMove, completion: {
                    message.stopRender(duration: 0.5)
                    message.removeFromParent()
                })
                SoundManager.sharedInstance().playSoundEffect(.messageBlock, mustLoop: false)
            }
        }else if playingState == .voiceOver2 || playingState == .blowDetecting{
            if message.position.x > -70 && !messageChanged{
                messageChanged = true
                self.messageParticle!.changeLine(strokeColor: .black, lineWidth: 25, glowWidth: 30)
                SoundManager.sharedInstance().playSoundEffect(.messageMess, mustLoop: false)
            }
            if message.position.x > 480{
                message.stopRender(duration: 0.0)
                message.position.x -= 10
                message.removeFromParent()
                SoundManager.sharedInstance().playSoundEffect(.darwinNo, mustLoop: false)
            }
        }else{
            if message.position.x > 480{
                message.stopRender(duration: 0.0)
                message.position.x -= 10
                message.removeFromParent()
                SoundManager.sharedInstance().playSoundEffect(.darwinYes, mustLoop: false)
            }
        }
    }
    
    private func updateMessageParticle(){
        self.messageParticle?.updateLine()
        self.messageParticle?.renderLine()
    }
}

extension SKAction {
    static func oscillation(amplitude a: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
        let action = SKAction.customAction(withDuration: Double(t)) { node, currentTime in
            let displacement = a * sin(2 * CGFloat.pi * currentTime / t)
            node.position.y = midPoint.y + displacement
        }

        return action
    }
}
