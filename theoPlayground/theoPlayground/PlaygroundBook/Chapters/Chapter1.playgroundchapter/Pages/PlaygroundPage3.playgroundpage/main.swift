/*:
 saefsefsaef
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
