import UIKit
class ZodiacViewModel: NSObject {
    var dataList: [UsInfoItem] = []
    func getData(complete: (([UsInfoItem]) -> Void)? ) {
        UserNetWork.PartnerUserList().lmrequest {[weak self] responseModel in
            guard let model = [UsInfoItem].deserialize(from: responseModel.data as? [Any]), let self = self else { return }
            let hisString = UserDefaults().string(forKey: "zodiacData")
            guard let array = [UsInfoItem].deserialize(from: hisString?.jsonStringToArray() as? [Any]) else {
                self.dataList = model
                complete?(self.dataList)
                return
            }
            let dataL = model.filter { person in
                !array.contains { $0.userId == person.userId }
            }
            self.dataList = dataL
            complete?(self.dataList)
        } failureBlock: { _ in
        }
    }
    func getzodiac(complete: ((zodiacModel) -> Void)? ) {
        CommonNetWork.zodiacRecommend().lmrequest {[weak self] responseModel in
            guard let model = zodiacModel.deserialize(from: responseModel.data as? [String: Any]), let self = self else { return }
            complete?(model)
        } failureBlock: { _ in
        }
    }
}
