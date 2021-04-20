/*:
 
 # The Wall
 - Note:
 Bowe got upset with something Darwin said. He wants to start a conversation about it, but...

 In many life situations, opening yourself to someone might feel very threatening. Your mind creates insecurities to stop you, like a giant wall that blocks every attempt of communication. Keeping things to yourself may seem easier, but we know it's not worth it.

 After a lot of effort, you will break the wall. The next challenge is avoiding being misunderstood. You need to speak as clear as possible, getting rid of all communication noises. Let's **BLOW** these noises away!

 Please, hit "Run My Code" to help Bowe!
 * Callout(Use Full Screen Mode for a better experience):
 Grab the slider in between the page and the Live View and move it by the page direction.

 When you’re done, go to the [next page](@next)!
 */

//#-hidden-code
import PlaygroundSupport
import SpriteKit
import BookCore

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 683, height: 1024))
if let scene = Main2(fileNamed: "Main2") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
//    sceneView.showsPhysics = true
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
