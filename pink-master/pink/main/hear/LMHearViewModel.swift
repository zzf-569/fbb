import UIKit
class LMHearViewModel: NSObject {
    override init() {
        super.init()
    }
    var type: Int = 0
    var page: Int = 1
    var roomList: [RoomItem] = []
    func getRoomList(complete: (([RoomItem]) -> Void)? ) {
        RoomNetWork.list(type: type, page: page).lmrequest { responseModel in
            guard let list = [RoomItem].deserialize(from: responseModel.data as? [Any]) else { return }
            if self.page == 1 {
                self.roomList = list
            } else {
                self.roomList.append(contentsOf: list)
            }
            complete?(self.roomList)
        } failureBlock: { _ in
        }
    }
    func getHotList(complete: (([RoomItem]) -> Void)? ) {
        set_NetWork.roomTopList(page: page, size: AppConfig.pageSize).lmrequest { responseModel in
            guard let list = [RoomItem].deserialize(from: responseModel.data as? [Any]) else { return }
            if self.page == 1 {
                self.roomList = list
            } else {
                self.roomList.append(contentsOf: list)
            }
            complete?(self.roomList)
        } failureBlock: { _ in
        }
    }
    @MainActor func turnToRoom(roomId: String) {
        RouteService.pushRoom(roomId)
    }
}
