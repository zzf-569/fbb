import Foundation
import ZegoExpressEngine
protocol RTCServiceDelegate: NSObjectProtocol {
    func rtcOnAudioVolumeIndicationUpdate(_ soundLevels: [String: NSNumber])
}
class RTCService: NSObject {
    weak var delegate: RTCServiceDelegate?
    private var streamId: String?
    static let shared = RTCService()
    private override init() {
        super.init()
        self.createEngine()
    }
}
private extension RTCService {
}
extension RTCService {
    func createEngine() {
        let profile = ZegoEngineProfile()
        profile.appID = UInt32(AppConfig.RTCInfo.appId)
        profile.appSign = AppConfig.RTCInfo.appSign
        profile.scenario = .karaoke
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
        let config = ZegoAudioConfig()
        config.bitrate = 192
        config.channel = .stereo
        config.codecID = .low3
        ZegoExpressEngine.shared().setAudioConfig(config, channel: .main)
    }
    func destroyEngine() {
        ZegoExpressEngine.destroy()
    }
    func enterRoom(_ roomId: String, rtcUserId: String, token: String) {
        let user = ZegoUser(userID: rtcUserId)
        let config = ZegoRoomConfig()
        config.token = token
        ZegoExpressEngine.shared().loginRoom(roomId, user: user, config: config)
        ZegoExpressEngine.shared().startSoundLevelMonitor()
    }
    func startPlayingStream(_ roomId: String, userId: String) {
        let config = ZegoPlayerConfig()
        config.roomID = roomId
        ZegoExpressEngine.shared().startPlayingStream(roomId + "_" + userId, config: config)
    }
    func stopPlayingStream(_ roomId: String, userId: String) {
        ZegoExpressEngine.shared().stopPlayingStream(roomId + "_" + userId)
    }
    func quitRoom() {
        ZegoExpressEngine.shared().stopSoundLevelMonitor()
        ZegoExpressEngine.shared().logoutRoom { _, _ in
        }
    }
    func startPublishingStream(_ streamId: String) {
        self.streamId = streamId
        ZegoExpressEngine.shared().startPublishingStream(streamId)
    }
    func stopPublishingStream() {
        streamId = nil
        ZegoExpressEngine.shared().stopPublishingStream()
    }
    func muteMicrophone(_ mute: Bool) {
        ZegoExpressEngine.shared().muteMicrophone(mute)
    }
    func isMicrophoneMuted() -> Bool {
        ZegoExpressEngine.shared().isMicrophoneMuted()
    }
    func enableHeadphoneMonitor(_ enabled: Bool) {
        ZegoExpressEngine.shared().enableHeadphoneMonitor(enabled)
    }
    func muteSpeaker(_ mute: Bool) {
        ZegoExpressEngine.shared().muteSpeaker(mute)
    }
    func set_AudioRouteToSpeaker(_ defaultToSpeaker: Bool) {
        ZegoExpressEngine.shared().setAudioRouteToSpeaker(defaultToSpeaker)
    }
    func set_CaptureVolume(_ value: Int) {
        ZegoExpressEngine.shared().setCaptureVolume(Int32(value))
    }
}
extension RTCService: ZegoEventHandler {
    func onDebugError(_ errorCode: Int32, funcName: String, info: String) {
        lmPrint("RTC #### errorCode:\(errorCode) \nfuncName:\(funcName) \ninfo:\(info)")
    }
    func onEngineStateUpdate(_ state: ZegoEngineState) {
        if state == .start {
            lmPrint("RTC #### SDK引擎正常")
        } else {
            lmPrint("RTC #### SDK引擎停止")
        }
    }
    func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable: Any], roomID: String) {
        lmPrint("RTC #### 房间连接状态变更：\(errorCode)")
    }
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        lmPrint("RTC #### 房间用户增加减少：\(userList)")
    }
    func onRoomOnlineUserCountUpdate(_ count: Int32, roomID: String) {
        lmPrint("RTC #### 房间用户在线数量：\(count)")
    }
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable: Any]?, roomID: String) {
        lmPrint("RTC #### 房间推拉流数量变更：updateType：\(updateType) \nstreamList:\(streamList)")
        for stream in streamList {
            if updateType == .add {
                let config = ZegoPlayerConfig()
                config.roomID = roomID
                ZegoExpressEngine.shared().startPlayingStream(stream.streamID, config: config)
            }
            if updateType == .delete {
                ZegoExpressEngine.shared().stopPlayingStream(stream.streamID)
            }
        }
    }
    func onRoomTokenWillExpire(_ remainTimeInSecond: Int32, roomID: String) {
        lmPrint("RTC #### 房间token即将过期")
    }
    func onPublisherStateUpdate(_ state: ZegoPublisherState, errorCode: Int32, extendedData: [AnyHashable: Any]?, streamID: String) {
        lmPrint("RTC #### 房间推流状态变更：state：\(state) \nerrorCode:\(errorCode) \nstreamID:\(streamID)")
    }
    func onCapturedSoundLevelUpdate(_ soundLevel: NSNumber) {
        guard let streamId = self.streamId else { return }
        var soundValue = soundLevel
        if isMicrophoneMuted() {
            soundValue = NSNumber(value: 0)
        }
        DispatchQueue.main.async {
            self.delegate?.rtcOnAudioVolumeIndicationUpdate([streamId: soundValue])
        }
    }
    func onRemoteSoundLevelUpdate(_ soundLevels: [String: NSNumber]) {
        DispatchQueue.main.async {
            self.delegate?.rtcOnAudioVolumeIndicationUpdate(soundLevels)
        }
    }
}
