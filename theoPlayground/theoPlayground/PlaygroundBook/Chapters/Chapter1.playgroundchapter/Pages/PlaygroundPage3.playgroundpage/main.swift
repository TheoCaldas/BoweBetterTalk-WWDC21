/*:
 # So, what should I do?

 Speaking your mind is a skill that takes years to master. We should all practice it in a daily basis, whether in a home, friendly or professional environment. The key to a good and healthy relationship is to externalize your feelings in a cloudless manner. Talk and make yourself understood!

 # A New Hope

 Thank you so much for being part of this journey!

 Bowe feels relieved for finally overcoming his fears. Now, he and Darwin can count on one another, always going for a clear and effective communication.

 The end.

 * Callout(Credits):
 Hi, there! My name is Theo and I'm a Computer Science student from Rio de Janeiro, Brazil. \
 All assets included in the project, such as images and audio files, were made exclusively by me.
 */

//#-hidden-code
import PlaygroundSupport
import SpriteKit
import BookCore

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 683, height: 1024))
if let scene = Main3(fileNamed: "Main3") {
    scene.scaleMode = .aspectFit
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//#-end-hidden-code
