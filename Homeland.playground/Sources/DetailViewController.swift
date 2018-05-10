import UIKit

protocol PopButtonDelegate: class {
    func pressedCloseButton(_ closeButton: PopButton)
    func pressedSpeechButton(_ speechButton: PopButton)
}

public class PopButton: UIButton {
    weak var delegate: PopButtonDelegate?
    let buttonName: String
    
    init(named: String, frame: CGRect) {
        buttonName = named
        super.init(frame: frame)
        self.layer.cornerRadius = 0
        if buttonName == "close" {
            self.addTarget(self, action: #selector(PopButton.didPressdClose(_sender:)), for: .touchDown)
        } else if buttonName == "speech" {
            self.addTarget(self, action: #selector(PopButton.didPressedSpeech(_sender:)), for: .touchDown)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressdClose(_sender: UIButton) {
        self.delegate?.pressedCloseButton(self)
    }
    
    @objc func didPressedSpeech(_sender: UIButton) {
        self.delegate?.pressedSpeechButton(self)
    }
}

public class DetailViewController: UIViewController {
    let detailView = DetailView(
        named: "earth",
        frame: CGRect(
            x: 0,
            y: 0,
            width: min(homeRect.width, homeRect.height) * 0.8,
            height: min(homeRect.width, homeRect.height) * 0.8
    ))
    let closeButton = PopButton(named: "close", frame: CGRect(x: 360, y: 10, width: 30, height: 30))
    let speechButton = PopButton(named: "speech", frame: CGRect(x: 15, y: 10, width: 30, height: 30))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = homeRect
        
        let closeImage = UIImage(named: "close3.png")
        let speechImage = UIImage(named: "speaker3.png")
        closeButton.setImage(closeImage, for: .normal)
        speechButton.setImage(speechImage, for: .normal)
        
        detailView.center = self.view.center
        detailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        detailView.layer.cornerRadius = 10
        detailView.addSubview(closeButton)
        detailView.addSubview(speechButton)
        
        // Layout Anchor
        
        let margins = detailView.layoutMarginsGuide
        speechButton.translatesAutoresizingMaskIntoConstraints = false  // important
        speechButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10).isActive = true
        speechButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10).isActive = true
        closeButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
        
        self.view.addSubview(detailView)
    }
}

