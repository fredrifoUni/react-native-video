@objc class UISliderDummy: UIControl {
    enum TargetType {
        case valueChanged
    }

    var isContinuous = true

    var value: Float = 0.0
    var minimumValue: Float = 0.0
    var maximumValue: Float = 0.0

    var minimumTrackTintColor: UIColor = .lighterGray
    var maximumTrackTintColor: UIColor = .darkGray
    var thumbTintColor: UIColor = .lighterGray

    func addTarget(_ target: Any, action: Selector, for: TargetType) {}
    func setValue(_ value: Float, animated: Bool) {}
}
