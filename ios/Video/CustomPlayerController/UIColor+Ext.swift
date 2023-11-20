
//MARK: Extensions
extension UIColor {
    static let lighterGray = UIColor(red: 254, green: 255, blue: 253, alpha: 1)

    init(findColor: (String) -> UIColor) {
        let color = findColor()
    }
}


let color = UIColor { colorRegister.grab("red") }
