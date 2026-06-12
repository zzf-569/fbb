import Foundation
struct PayService {
    static func pay(_ type: PayType, payModel: PayServiceModel, product: RechargeItem, completeblock: @escaping (PayType, RechargeItem, LMError?) -> Void) {
        switch type {
        case .apple:
            ApplePayService.shared.pay(orderId: payModel.outTradeNo, item: product) { model, error in
                completeblock(type, model, error)
            }
        case .wechat:
            break
        case .ali:
            break
        }
    }
}
