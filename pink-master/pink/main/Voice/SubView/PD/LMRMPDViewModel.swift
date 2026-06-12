import Foundation
class LMRMPDViewModel: NSObject {
    var status: RoomPDStatus = .normal
    var DispatchItem: DispatchItem?
    var sequenceList: [UsInfoItem] = []
    var isInSequence: Bool {
        if sequenceList.first(where: { $0.userId == UserShared.user?.userId }) != nil {
            return true
        } else {
            return false
        }
    }
    func enterRoom(roomId: String, block: @escaping () -> Void) {
        updateDaRenlist(roomId:roomId) {
            block()
        }
    }
    func updateDaRenlist(roomId: String, block: @escaping () -> Void) {
        RoomPDApi.daRenlist(roomId:roomId).lmrequest { [weak self] responseModel in
            guard let self = self else { return }
            guard let list = [UsInfoItem].deserialize(from: responseModel.data as? [Any]) else { return }
            self.sequenceList = list
            block()
        } failureBlock: { _ in
            block()
        }
    }
}
