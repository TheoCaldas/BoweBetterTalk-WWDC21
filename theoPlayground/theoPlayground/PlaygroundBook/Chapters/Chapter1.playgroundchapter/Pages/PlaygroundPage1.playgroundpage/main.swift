/*:
 
 # Repressed Feelings
 Just like Bowe, you may often find yourself with repressed feelings in your chest. It might be hard to release the heaviness from inside. Then, the best you can do is to **SHOUT** it all out!
 
 * Important:
 Although it feels good to spill out these awful thoughts, it doesn't solve any problem. Your inner struggle will only vanish through communication. When possible, try talking about the things that bother you with friends, family or any person you trust and feel comfortable with.
 
 
Please, hit "Run My Code" to help Bowe!
  * Callout(Use Full Screen Mode for a better experience):
    Grab the slider in between the page and the Live View and move it by the page direction.
 
When you’re done, go to [next page](@next)!
*/
//#-hidden-code
import PlaygroundSupport
import SpriteKit
import BookCore
//#-end-hidden-code


//#-hidden-code
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 683, height: 1024))
if let scene = Main1(fileNamed: "Main1") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
