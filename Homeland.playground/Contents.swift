import UIKit
import SceneKit
import PlaygroundSupport
/*:
 ## Homeland
 This playground uses **SceneKit** to create a [Earth](https://en.wikipedia.org/wiki/Earth) [Moon](https://en.wikipedia.org/wiki/Moon) system. It is our beautiful homeland, as shown in the following figure. The "Mother Earth" refreshes my memory of coding first "Hello World". The scene will start with a cool opening animation.
  
 ![Earth-Moon](Earth-Moon.png)
  
 The models of the earth and the moon are created in *Scene Editor*.This approach is very intuitive and efficient. The scene is mainly achieved using SCNAction API. In addition, you can interact with it through some gesture.
 ### Interactions
 1. **Tap**: touch the earth or the moon will pop up a detail. Then click voice button to speech utterance. Finally click close button or on the outside to close detail view.
 2. **Double tap**: double clicks in the space will show effect of comet and reset point of view. If you double clicks when the comet is moving, the scene will change point of view instead of creating other comet.
 3. **Long press**: long press in the space will switch the angle.
 4. **Swipe**: swipe down can zoom in and swipe up can zoom out. Only three distances can you switch. By the way, you should swipe quickly to distinguish between drag gestures.
 5. **Pan**: Drag the scene to look at it from all angle.
 */
/*:
 ### Size
 Set the appropriate view size to display dynamic scene.
 */
homeRect = CGRect(x: 0, y: 0, width: 900, height: 600)
/*:
 ### Initialization
 Loading a scene already created in the Scene Editor. You can also find the files in Resources and edit them by yourself.
 */
let home = HomelandView(sceneName: "scene_homeland.scn")
PlaygroundPage.current.liveView = home
PlaygroundPage.current.needsIndefiniteExecution = true
/*:
 ### Rotation
 Make the earth and the moon rotate. The axial tilt of the earth is equal to 23.44°, and the moon also has axial tilt, which is equal to 6.68°. An interesting phenomenon, since the moon rotates around the same cycle as the rotation cycle around the earth, it's 27.3 days, so it's always been on the same side for one billion years.
*/
home.rotation(node: home.earthNode, axialTilt: -23.44, time: 1)
home.rotation(node: home.moonNode, axialTilt: -6.68, time: 27.3)
/*:
 ### Revolution
 Here is simulated revolution of the earth and the moon. On average, the distance from Earth to the moon is about 384,400 km, and distance to the sun is about 149.6 million km. But from Earth's surface, the apparent sizes of the Sun and the Moon are approximately the same.
 */
home.revolution(node: home.earthNode, radius: 149597870, time: 365)
home.revolution(node: home.moonNode, radius: 384400, time: 27.3)
/*:
 ### Comet
 You can set the color of the comet to random, or set default color. The movement of the comet are accompanied by some positional sound effects.
 */
home.isRandomColor = false
home.cometDefaultColor = UIColor.lightblue
/*:
 ### Detail
 You can edit the following contents and show them in the detail view. And set utterance rate and volume, then click button to speech it.
 */
home.rate = 0.45
home.volume = 0.6
home.earthInfo = "Earth is the third planet from the Sun and the only object in the Universe known to harbor life. It is the densest planet in the Solar System and the largest of the four terrestrial planets.\nDuring one orbit around the Sun, Earth rotates about its axis over 365 times; thus, an Earth year is about 365.26 days long. Earth's axis of rotation is tilted, producing seasonal variations on the planet's surface. The gravitational interaction between the Earth and Moon causes ocean tides, stabilizes the Earth's orientation on its axis, and gradually slows its rotation."
home.moonInfo = "The Moon is an astronomical body that orbits planet Earth, being Earth's only permanent natural satellite. It is the fifth-largest natural satellite in the Solar System.\nThere are several hypotheses for its origin; the most widely accepted explanation is that the Moon formed from the debris left over after a giant impact between Earth and a Mars-sized body called Theia."
