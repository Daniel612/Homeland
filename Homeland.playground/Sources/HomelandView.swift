import UIKit
import SceneKit
import AVFoundation
import PlaygroundSupport

public var homeRect = CGRect()

public class HomelandView: SCNView, PopButtonDelegate, AVSpeechSynthesizerDelegate {
    
    // MARK: Properties
    
    // static of pointOfView's yFox
    enum ViewStatic: Int {
        case small = 1
        case normal
        case large
    }
    var viewStatic = 2
    
    // set the scene name in playground
    public var sceneName: String {
        get {
          return self.sceneName
        }
        set {
            self.sceneName = newValue
        }
    }
    
    // creat a SCNView
    public var scnView: SCNView!
    
    // create a SCNScene
    public var scnScene: SCNScene!
    
    public var earthNode: SCNNode!
    public var moonNode: SCNNode!
    var staticCameraNode: SCNNode!
    var followMoonCameraNode: SCNNode!
    var moonStaticCameraNode: SCNNode!
    var earthStaticCameraNode: SCNNode!
    var omniNode: SCNNode!
    public var isRandomColor = false
    public var cometDefaultColor = UIColor.lightblue
    public var earthInfo = ""
    public var moonInfo = ""
    
    var doubleTapRecognizer = UITapGestureRecognizer()
    
    // instantiate a DetailViewController
    let vc = DetailViewController()
    
    // speech variable
    let synth = AVSpeechSynthesizer()
    public var utterance = AVSpeechUtterance(string: "")
    public var rate: Float!
    public var volume: Float!
    
    // visual effect
    let blurEffect: UIBlurEffect
    let blurView: UIVisualEffectView
    var effect: UIVisualEffect!
    
    
    // MARK: Initialization
    public init(sceneName: String) {
        
        // blur effect
        blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = homeRect
        
        super.init(frame: homeRect, options: nil)
        
        // set up scene
        scnScene = SCNScene(named: sceneName)
        self.scene = scnScene
        self.allowsCameraControl = true
        scnView = self
        
        if sceneName == "scene_homeland.scn" {
            setupNode()
        }
        
        // add detailView to blurView's content
        blurView.contentView.addSubview(vc.view)
        
        // play music in the background thread, it will run long time
        DispatchQueue.global(qos: .utility).async { [weak self]
            () -> Void in
            self?.setupBackgroundMusic()
        }
        
        // set button's delegate
        vc.closeButton.delegate = self
        vc.speechButton.delegate = self
        
        setupGestureRecognizer()
        
        // set up opening animation
        pointOfView = staticCameraNode
        openingAnimation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        // bind the node of scene
        earthNode = scnScene.rootNode.childNode(withName: "earth", recursively: true)!
        moonNode = scnScene.rootNode.childNode(withName: "moon", recursively: true)!
        staticCameraNode = scnScene.rootNode.childNode(withName: "camera", recursively: true)!
        followMoonCameraNode = scnScene.rootNode.childNode(withName: "followMoon_camera", recursively: true)!
        moonStaticCameraNode = scnScene.rootNode.childNode(withName: "moonStatic_camera", recursively: true)!
        earthStaticCameraNode = scnScene.rootNode.childNode(withName: "earthStatic_camera", recursively: true)!
        omniNode = scnScene.rootNode.childNode(withName: "omni", recursively: true)!
        
        let constraint = SCNLookAtConstraint(target: moonNode)
        followMoonCameraNode.constraints = [constraint]
    }
    
    private func setupBackgroundMusic() {
        let source = SCNAudioSource(named: "space.mp3")
        source?.loops = true
        source?.isPositional = false
        let player = SCNAudioPlayer(source: source!)
        scnScene.rootNode.addAudioPlayer(player)
        let play = SCNAction.playAudio(source!, waitForCompletion: true)
        scnScene.rootNode.runAction(play)
    }
    
    private func setupGestureRecognizer() {
        
        // Single tap
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetailView(sender:)))
        singleTapRecognizer.location(in: scnView)
        self.addGestureRecognizer(singleTapRecognizer)
        
        // Double tap
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cometMotion))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRecognizer)
        
        // Long press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.addGestureRecognizer(longPressRecognizer)
        
        // Close detailView when tap outside
        let tapOutsideDetailiViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressedCloseButton(_:)))
        tapOutsideDetailiViewRecognizer.cancelsTouchesInView = false
        tapOutsideDetailiViewRecognizer.delegate = self
        self.addGestureRecognizer(tapOutsideDetailiViewRecognizer)
        
        // Upward swipe
        let upwardSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(HomelandView.enlargeView))
        upwardSwipeRecognizer.direction = .up
        self.addGestureRecognizer(upwardSwipeRecognizer)
        
        // Downwarf swipe
        let downwardSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(HomelandView.narrowView))
        downwardSwipeRecognizer.direction = .down
        self.addGestureRecognizer(downwardSwipeRecognizer)
    }
    
    func showDetailView(sender: UITapGestureRecognizer) {
            let touchLocation = sender.location(in: scnView)
            let hitResults = scnView.hitTest(touchLocation, options: nil)
            let hitView = scnView.hitTest(touchLocation, with: nil)
            if hitView == self {
                if let result = hitResults.first {
                    vc.detailView.titleLabel.text = result.node.name
                    if result.node.name == "Earth" {
                        vc.detailView.textView.text = earthInfo
                        animateTo(earthStaticCameraNode)
                    } else if result.node.name == "Moon" {
                        vc.detailView.textView.text = moonInfo
                        animateTo(moonStaticCameraNode)
                    }
                    animateIn()
                }
            }
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            
        } else if sender.state == .began {
            animatePointOfView()
        }
    }
    
    // MARK: SCNTransaction of point of view
    
    func openingAnimation() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 20
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 10
            self.pointOfView = self.staticCameraNode
            SCNTransaction.commit()
        }
        pointOfView = followMoonCameraNode
        SCNTransaction.commit()
    }
    
    func animatePointOfView() {
        if pointOfView != followMoonCameraNode {
            animateTo(followMoonCameraNode)
        } else if pointOfView != staticCameraNode {
            animateTo(staticCameraNode)
        }
        viewStatic = ViewStatic.normal.rawValue
    }
    
    func animateTo(_ node: SCNNode) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.7
        pointOfView = node
        SCNTransaction.commit()
    }
    
    func enlargeView() {
        if viewStatic > ViewStatic.small.rawValue {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.7
            SCNTransaction.completionBlock = {
                self.viewStatic = self.viewStatic - 1
            }
            pointOfView?.camera?.yFov = (pointOfView?.camera?.yFov)!*2.0
            SCNTransaction.commit()
        }
    }
    
    func narrowView() {
        if viewStatic < ViewStatic.large.rawValue {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.7
            SCNTransaction.completionBlock = {
                self.viewStatic = self.viewStatic + 1
            }
            pointOfView?.camera?.yFov = (pointOfView?.camera?.yFov)!*0.5
            SCNTransaction.commit()
        }
    }
    
    // MARK: Use SCNAction to simulate movement
    
    // Rotaion
    public func rotation(node: SCNNode, axialTilt: Double, time: TimeInterval) {
        var realTime: TimeInterval = time
        let radian = (axialTilt / 180) * .pi
        if node == earthNode {
            realTime = time * 10
        }
        node.eulerAngles = SCNVector3(radian,0,0)
        node.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi, around: SCNVector3(0,1,tan(radian)), duration: realTime)))
    }
    
    // Revolution
    public func revolution(node: SCNNode, radius: Double, time: TimeInterval) {
        let centerNode = SCNNode()
        var rotationNode = node
        var realRadius: Double = 0
        if rotationNode.name == "moon" {
            rotationNode.scale = SCNVector3(0.27,0.27,0.27)
            followMoonCameraNode.position = SCNVector3(-3, 0, 0)
            realRadius = (radius / 384400) * 2
        } else if rotationNode.name == "earth" {
            rotationNode = omniNode
            realRadius = (radius / 149597870) * 100
        }
        centerNode.position = SCNVector3(0, 0, 0)
        scnScene.rootNode.addChildNode(centerNode)
        rotationNode.position = SCNVector3(-realRadius, 0, 0)
        centerNode.addChildNode(rotationNode)
        centerNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi, around: SCNVector3(0,1,0), duration: time)))
    }
    
    // Comet
    private func createComet(named: String) -> SCNNode {
        let particle = SCNParticleSystem(named: named, inDirectory: nil)!
        if isRandomColor {
            particle.particleColor = UIColor.random()
        } else {
            particle.particleColor = cometDefaultColor
        }
        
        let cometNode = SCNNode()
        cometNode.name = "comet"
        cometNode.addParticleSystem(particle)
        return cometNode
    }
    
    // Simulating comet action
    func cometMotion() {
        let cometNode = createComet(named: "fire.scnp")
        let cometRotateDistance = staticCameraNode.position.z
        let centerNode = SCNNode()
        centerNode.position = SCNVector3(cometRotateDistance*0.5,0,0)
        cometNode.position = SCNVector3(0.5, 0, cometRotateDistance*1.4)
        centerNode.addChildNode(cometNode)
        if doubleTapRecognizer.isEnabled {
            scnScene.rootNode.addChildNode(centerNode)
        }
        let moveAction = SCNAction.rotate(by: CGFloat(-.pi*1.3), around: SCNVector3(0,1,0), duration: 20)
        let finishAction = SCNAction.run { (_) in
            self.doubleTapRecognizer.isEnabled = true
        }
        let removeAction = SCNAction.removeFromParentNode()
        
        // sound
        let source = SCNAudioSource(named: "rumble.mp3")
        source?.loops = true
        source?.isPositional = true
        let player = SCNAudioPlayer(source: source!)
        cometNode.addAudioPlayer(player)
        let play = SCNAction.playAudio(source!, waitForCompletion: true)
        play.timingMode = .easeInEaseOut
        cometNode.runAction(play)
        scnView.audioListener = earthNode
        
        centerNode.runAction(SCNAction.sequence([moveAction, finishAction, removeAction]))
        
        // reset camera's position
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.7
        scnView.pointOfView = staticCameraNode
        SCNTransaction.commit()
        
        // reset view static
        viewStatic = ViewStatic.normal.rawValue
        
        // forbid to double tapping
        doubleTapRecognizer.isEnabled = false
    }

    
    // MARK: Button Handling
    
    func pressedCloseButton(_ closeButton: PopButton) {
        animateOut()
        synth.stopSpeaking(at: .immediate)
        animateTo(staticCameraNode)
    }
    
    func pressedSpeechButton(_ speechButton: PopButton) {
        synth.stopSpeaking(at: .immediate)
        utterance = AVSpeechUtterance(string: vc.detailView.textView.text!)
        utterance.rate = rate
        utterance.volume = volume
        DispatchQueue.global(qos: .userInteractive).async { [weak self]
            () -> Void in
            self?.synth.delegate = self
            self?.synth.speak((self?.utterance)!)
        }
    }
    
    // highlight the word currently being spoken.
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0, green: 0.6843549609, blue: 0.7921464443, alpha: 1), range: characterRange)
        vc.detailView.textView.attributedText = mutableAttributedString
        vc.detailView.textView.font = UIFont.systemFont(ofSize: 18)
        vc.detailView.textView.textAlignment = .justified
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        vc.detailView.textView.attributedText = NSAttributedString(string: utterance.speechString)
        vc.detailView.textView.font = UIFont.systemFont(ofSize: 18)
        vc.detailView.textView.textAlignment = .justified
    }
    
    // MARK: Animation
    
    func animateIn() {
        self.addSubview(blurView)
        
        // prepare
        vc.detailView.transform = CGAffineTransform(scaleX: 0, y: 0)
        vc.detailView.alpha = 0
        blurView.effect = nil
        
        UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5) {
            self.vc.detailView.alpha = 1
            self.vc.detailView.transform = CGAffineTransform.identity
        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.blurView.effect = self.blurEffect
        }.startAnimation()
        
    }
    
    func animateOut() {
        let yAixsOffset = min(homeRect.width, homeRect.height) * 0.9
        
        let animatorOut = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.blurView.effect = nil
            self.vc.detailView.alpha = 0
            self.vc.detailView.transform = CGAffineTransform(a: 0.7, b: 0, c: 0, d: 0.7, tx: 0, ty: yAixsOffset)
        }
        animatorOut.addCompletion { (_) in
            self.blurView.removeFromSuperview()
        }
        animatorOut.startAnimation()
    }
}

// return ture when the touch on background
extension HomelandView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === vc.view)
    }
}
