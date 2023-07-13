import Foundation
import GoogleInteractiveMediaAds

class RCTIMAAdsManager: NSObject, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {

    private var _video:RCTVideo

    /* Entry point for the SDK. Used to make ad requests. */
    private var adsLoader: IMAAdsLoader!
    /* Main point of interaction with the SDK. Created by the SDK as the result of an ad request. */
    private var adsManager: IMAAdsManager!

    init(video:RCTVideo!) {
        _video = video

        super.init()
    }

    func setUpAdsLoader() {
        let settings = IMASettings()
        settings.disableNowPlayingInfo = true
        settings.enableBackgroundPlayback = false
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }

    func requestAds() -> Bool {
        // Create ad display container for ad rendering.
        if _video._playerViewController != nil {
            // Initiate AD container 
            #if os(iOS)
            let adDisplayContainer = IMAAdDisplayContainer(adContainer: _video._playerViewController!.view, viewController: _video._playerViewController)
            #else
            let adDisplayContainer = IMAAdDisplayContainer(adContainer: _video._playerViewController!.contentOverlayView!, viewController: _video._playerViewController!)
            #endif
            
            let adTagUrl = _video.getAdTagUrl()
            let contentPlayhead = _video.getContentPlayhead()

            if adTagUrl != nil && contentPlayhead != nil {
                // Create an ad request with our ad tag, display container, and optional user context.
                let request = IMAAdsRequest(
                    adTagUrl: adTagUrl!,
                    adDisplayContainer: adDisplayContainer,
                    contentPlayhead: contentPlayhead,
                    userContext: nil)

                adsLoader.requestAds(with: request)
                return true
            }
        } // TODO: Handle player layer ads
        return false
    }

    // MARK: - Getters

    func getAdsLoader() -> IMAAdsLoader? {
        return adsLoader
    }

    func getAdsManager() -> IMAAdsManager? {
        return adsManager
    }

    // MARK: - IMAAdsLoaderDelegate
    // -adsLoader:adsLoadedWithData:
    // Called when ads are successfully loaded from the ad servers by the loader.
    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        // Grab the instance of the IMAAdsManager and set yourself as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self


        // Create ads rendering settings and tell the SDK to use the in-app browser.
        let adsRenderingSettings: IMAAdsRenderingSettings = IMAAdsRenderingSettings();
        adsRenderingSettings.linkOpenerPresentingController = _video.reactViewController();

        adsManager.initialize(with: adsRenderingSettings)
    }

    // -adsLoader:failedWithErrorData
    // Error reported by the ads loader when loading or requesting an ad fails.
    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        if adErrorData.adError.message != nil {
            print("Error loading ads: " + adErrorData.adError.message!)
        }

        _video.setPaused(false)
    }

    // MARK: - IMAAdsManagerDelegate

    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }

        let type = convertEventToString(event: event.type)
        _video.receivedAdEvent(event: event);
    
    }

    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        if error.message != nil {
            print("AdsManager error: " + error.message!)
        }

        // Fall back to playing content
        _video.setPaused(false)
    }

    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        // Prevent seeking while AD is playing
        #if os(tvOS)
        _video._playerViewController?.showsPlaybackControls = false
        #endif
        
        // Pause the content for the SDK to play ads.
        _video.setPaused(true)
        _video.setAdPlaying(true)
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        // Allow seeking while video is playing
        #if os(tvOS)
        _video._playerViewController?.showsPlaybackControls = true
        #endif
        
        // Resume the content since the SDK is done playing ads (at least for now).
        _video.setAdPlaying(false)
        _video.setPaused(false)
    }

    // MARK: - Helpers

    func convertEventToString(event: IMAAdEventType!) -> String {
        var result = "UNKNOWN";

        switch(event) {
            case .AD_BREAK_READY:
                result = "AD_BREAK_READY";
                break;
            case .AD_BREAK_ENDED:
                result = "AD_BREAK_ENDED";
                break;
            case .AD_BREAK_STARTED:
                result = "AD_BREAK_STARTED";
                break;
            case .AD_PERIOD_ENDED:
                result = "AD_PERIOD_ENDED";
                break;
            case .AD_PERIOD_STARTED:
                result = "AD_PERIOD_STARTED";
                break;
            case .ALL_ADS_COMPLETED:
                result = "ALL_ADS_COMPLETED";
                break;
            case .CLICKED:
                result = "CLICK";
                break;
            case .COMPLETE:
                result = "COMPLETE";
                break;
            case .CUEPOINTS_CHANGED:
                result = "CUEPOINTS_CHANGED";
                break;
            case .FIRST_QUARTILE:
                result = "FIRST_QUARTILE";
                break;
            case .LOADED:
                result = "LOADED";
                break;
            case .LOG:
                result = "LOG";
                break;
            case .MIDPOINT:
                result = "MIDPOINT";
                break;
            case .PAUSE:
                result = "PAUSED";
                break;
            case .RESUME:
                result = "RESUMED";
                break;
            case .SKIPPED:
                result = "SKIPPED";
                break;
            case .STARTED:
                result = "STARTED";
                break;
            case .STREAM_LOADED:
                result = "STREAM_LOADED";
                break;
            case .TAPPED:
                result = "TAPPED";
                break;
            case .THIRD_QUARTILE:
                result = "THIRD_QUARTILE";
                break;
            default:
                result = "UNKNOWN";
        }

        return result;
    }
}
