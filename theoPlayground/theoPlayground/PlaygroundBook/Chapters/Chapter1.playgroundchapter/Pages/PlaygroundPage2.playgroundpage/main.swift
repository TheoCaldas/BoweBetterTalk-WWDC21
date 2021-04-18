/*:
 
 # The Wall
 - Note:
 Bowe got upsed about something Darwin said. He wants to start a conversation about what's bothering him so much. But...

 In many life situations, you will feel uncomfortable trying to open yourself to someone, even when they are close to you. In fact, the task might look very threatening, as your mind creates insecurities to stop you, just like a giant wall that blocks every attempt of communication. Giving up and keeping things to yourself seems easier, but we know it's not worth it.

 After a lot of effort, you will break the wall. But, even then, you may face the problem of being misunderstood, after saying what you really needed to say. Therefore, you need to speak as clear as possible, getting rid of all communication noises. Let's **BLOW** these noises away!

 Please, hit "Run My Code" to help Bowe!
   * Callout(Use Full Screen Mode for a better experience):
     Grab the slider in between the page and the Live View and move it by the page direction.
  
 When you’re done, go to [next page](@next)!
 */

//#-hidden-code
import PlaygroundSupport
import SpriteKit
import BookCore

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 683, height: 1024))
if let scene = Main2(fileNamed: "Main2") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
    sceneView.showsPhysics = true
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
