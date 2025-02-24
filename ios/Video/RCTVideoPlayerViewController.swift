import AVKit

class RCTVideoPlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    weak var rctDelegate: RCTVideoPlayerViewControllerDelegate?
    
    // Optional paramters
    var preferredOrientation: String?
    var autorotate: Bool?
    
    // Content rating
    var dislikeButton: UIAction?
    var likeButton: UIAction?
    var contentRating = 0 {
        didSet { refreshLikeButtons() }
    }

    func shouldAutorotate() -> Bool {
        if autorotate! || preferredOrientation == nil || (preferredOrientation!.lowercased() == "all") {
            return true
        }

        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.playbackControlsIncludeTransportBar = true
        self.showsPlaybackControls = true
        
        // Content rating
        initContentRatingButtons()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        rctDelegate?.videoPlayerViewControllerWillDismiss(playerViewController: self)
        rctDelegate?.videoPlayerViewControllerDidDismiss(playerViewController: self)
    }

    #if !os(tvOS)

        func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return .all
        }

        func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
            if preferredOrientation?.lowercased() == "landscape" {
                return .landscapeRight
            } else if preferredOrientation?.lowercased() == "portrait" {
                return .portrait
            } else {
                // default case
                if #available(iOS 13, tvOS 13, *) {
                    return RCTVideoUtils.getCurrentWindow()?.windowScene?.interfaceOrientation ?? .unknown
                } else {
                    #if !os(visionOS)
                        return UIApplication.shared.statusBarOrientation
                    #endif
                }
            }
        }

    #endif
}

// Content Rating extension
extension RCTVideoPlayerViewController {
    private func initContentRatingButtons() {
        guard #available(tvOS 15.0, *) else { return }
        
        // Add the content-rating buttons to the transportBar
        likeButton = createAction(title: "Like", handler: onLikePressed)
        dislikeButton = createAction(title: "Dislike", handler: onDislikePressed)
        transportBarCustomMenuItems = [likeButton!, dislikeButton!]
        refreshLikeButtons()
    }
    
    public func onLikePressed(){
        let newRating = self.contentRating == 1 ? 0: 1
        rctDelegate?.onContentRating(rating: newRating)
    }
    
    public func onDislikePressed(){
        let newRating = self.contentRating == -1 ? 0: -1
        rctDelegate?.onContentRating(rating: newRating)
    }
    
    // Content rating
    private func refreshLikeButtons() {
        guard #available(tvOS 15.0, *) else { return }
        
        // Refresh the images to reflect selection state
        let likeButtonImage = UIImage(systemName: self.contentRating == 1 ? "hand.thumbsup.fill": "hand.thumbsup")
        let dislikeButtonImage = UIImage(systemName: self.contentRating == -1 ? "hand.thumbsdown.fill": "hand.thumbsdown")
    
        likeButton?.image = likeButtonImage
        dislikeButton?.image = dislikeButtonImage
    }
    
    public func setContentRating(_ rating: Int) {
        contentRating = rating
    }
    
    func createAction(title: String, handler: @escaping () -> Void) -> UIAction? {
        guard #available(tvOS 15.0, *) else { return nil }
        
        return UIAction(title: title){
            _ in handler()
        }
    }
}
