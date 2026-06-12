import Foundation
public func kImUserId(userId: String) -> String { "pink-" + userId }
public func kImUserId(converID: String) -> String { converID.removeSomeStringUseSomeString(removeString: "c2c_") }
public func kUserId(imUserId: String) -> String { imUserId.removeCharacter(characterString: "pink-") }
public func kUserId(converID: String) -> String { converID.removeSomeStringUseSomeString(removeString: "c2c_pink-") }
public func kConversationId(userId: String) -> String { "c2c_" + "pink-" + userId }
public func kConversationId(imUserId: String) -> String { "c2c_" + imUserId }
