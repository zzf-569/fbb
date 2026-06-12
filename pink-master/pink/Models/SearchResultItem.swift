import Foundation
struct SearchResultItem: SmartCodable {
    var type: SearchResult = .defaultCase
    var partyList: [RoomItem] = []
    var personList: [RoomItem] = []
    var userList: [UsInfoItem] = []
    var commandRoom: [RoomItem] = []
    var commandUser: [UsInfoItem] = []
    var exactRoomList: [RoomItem] = []
    var exactUserList: [UsInfoItem] = []
}
