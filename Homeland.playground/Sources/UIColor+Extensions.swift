import UIKit

let UIColorList:[UIColor] = [
    UIColor.lightgreen,
    UIColor.lightpurple,
    UIColor.lightyellow,
    UIColor.lightblue
]

extension UIColor {
  
    public static func random() -> UIColor {
        let maxValue = UIColorList.count
        let rand = Int(arc4random_uniform(UInt32(maxValue)))
        return UIColorList[rand]
    }
    
    public static var lightblue: UIColor {
        return UIColor(red: 105/255, green: 236/255, blue: 255/255, alpha: 1.0)
    }
    
    public static var lightgreen: UIColor {
        return UIColor(red: 124/255, green: 249/255, blue: 132/255, alpha: 1.0)
    }
    
    public static var lightpurple: UIColor {
        return UIColor(red: 200/255, green: 142/255, blue: 249/255, alpha: 1.0)
    }
    
    public static var lightyellow: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 102/255, alpha: 1.0)
    }
}
