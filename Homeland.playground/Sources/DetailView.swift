import UIKit

public class DetailView: UIView {
    
    // Label
    var titleLabel = UILabel(frame: .zero)
    var textView = UITextView()
    
    public init(named: String, frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // textView
        textView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        textView.contentMode = .scaleAspectFit
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.textAlignment = .justified
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView
        let topStackView = UIStackView(arrangedSubviews: [titleLabel])
        
        let infoStackView = UIStackView(arrangedSubviews: [topStackView, textView])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        
        self.addSubview(infoStackView)
        
        // Layout
        let views = ["stackView": infoStackView]
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[stackView]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: [], metrics: nil, views: views)
        layoutConstraints.append(titleLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor, constant: 10))
        layoutConstraints.append(titleLabel .trailingAnchor.constraint(equalTo: topStackView.trailingAnchor, constant: 10))
        layoutConstraints.append(titleLabel.topAnchor.constraint(equalTo: topStackView.topAnchor, constant: 10))
        layoutConstraints.append(textView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
