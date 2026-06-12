import Foundation
import StoreKit
class ApplePayService: NSObject {
    static let shared = ApplePayService()
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    private var orderId: String?
    private var productModel: RechargeItem?
    private var payCompleteblock: ((RechargeItem, LMError?) -> Void)?
    private var receipt: String = ""
    func pay(orderId: String, item model: RechargeItem, complete block: ((RechargeItem, LMError?) -> Void)?) {
        self.orderId = orderId
        self.productModel = model
        self.payCompleteblock = block
        guard let productModel = self.productModel else {
            payComplete(error: LMError(code: 999, message: "未找到该商品"))
            return
        }
        let request = SKProductsRequest(productIdentifiers: [productModel.appleProductId])
        request.delegate = self
        request.start()
        lmPrint("苹果支付：productId: \(productModel.appleProductId), start request：\(request)")
    }
    func payComplete(error: LMError?) {
        DispatchQueue.main {
            self.payCompleteblock?(self.productModel!, error)
        }
    }
}
private extension ApplePayService {
    func payFinish(_ transaction: SKPaymentTransaction) {
        serviceVisaVerification(transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    func serviceVisaVerification(_ transaction: SKPaymentTransaction) {
        guard let receiptString = getServiceVisaVerificationData(transaction) else {
            payComplete(error: LMError(code: 999, message: "没有找到支付凭证"))
            return
        }
        guard let orderId = orderId else {
            payComplete(error: LMError(code: 999, message: "没有找到订单凭证"))
            return
        }
        if receipt == receiptString {
            return
        }
        receipt = receiptString
        WalletNetWork.appleConfirm(outTradeNo: orderId, receipt: receiptString).lmrequest { [weak self] _ in
            guard let self = self else { return }
            self.receipt = ""
            self.payComplete(error: nil)
        } failureBlock: { [weak self] error in
            self?.receipt = ""
            self?.payComplete(error: LMError(code: error.code, message: error.message))
        }
    }
    func getServiceVisaVerificationData(_ transaction: SKPaymentTransaction) -> String? {
        guard let recepitURL = Bundle.main.appStoreReceiptURL else { return nil }
        do {
            let receipt = try Data(contentsOf: recepitURL)
            let receiptString = receipt.base64EncodedString(options: .endLineWithLineFeed)
            return receiptString
        } catch {
            return nil
        }
    }
    func localVisaVerification(_ transaction: SKPaymentTransaction, isTest: Bool) {
        guard let lmrequestData = getLocalVisaVerificationData(transaction) else {
            payComplete(error: LMError(code: 999, message: "没有找到支付凭证"))
            return
        }
        var serverStr = "https://buy.itunes.apple.com/verifyReceipt"
        if isTest {
            serverStr = "https://sandbox.itunes.apple.com/verifyReceipt"
        }
        guard let storeURL = URL(string: serverStr) else {
            payComplete(error: LMError(code: 999, message: "没有找到支付凭证"))
            return
        }
        var storeRequest = URLRequest(url: storeURL)
        storeRequest.httpMethod = "POST"
        storeRequest.httpBody = lmrequestData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: storeRequest) { data, _, error in
            if let error = error {
                self.payComplete(error: LMError(code: 999, message: error.localizedDescription))
            } else {
                guard let data = data else {
                    self.payComplete(error: LMError(code: 999, message: "没有找到支付凭证"))
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let status = jsonResponse?["status"] as? String
                    if status == "21007" {
                        self.localVisaVerification(transaction, isTest: true)
                    } else if status == "0" {
                        self.payComplete(error: nil)
                    } else {
                        self.payComplete(error: LMError(code: 999, message: "支付凭证验证失败"))
                    }
                } catch {
                    self.payComplete(error: LMError(code: 999, message: "没有找到支付凭证"))
                }
            }
        }
        dataTask.resume()
    }
    func getLocalVisaVerificationData(_ transaction: SKPaymentTransaction) -> Data? {
        guard let recepitURL = Bundle.main.appStoreReceiptURL else { return nil }
        do {
            let receipt = try Data(contentsOf: recepitURL)
            let requestContents = ["receipt-data": receipt.base64EncodedString()]
            do {
                let lmrequestData = try JSONSerialization.data(withJSONObject: requestContents)
                return lmrequestData
            } catch {
                return nil
            }
        } catch {
            return nil
        }
    }
}
extension ApplePayService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        lmPrint("苹果支付：productsRequest：\(request), response:\(response)")
        if let product = response.products.first(where: { $0.productIdentifier == productModel?.appleProductId }) {
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            } else {
                print("User can't make payments")
                payComplete(error: LMError(code: 999, message: "不支持苹果支付"))
            }
        } else {
            payComplete(error: LMError(code: 999, message: "未找到该商品"))
        }
    }
    func lmrequestDidFinish(_ request: SKRequest) {
        lmPrint("苹果支付：requestDidFinish：\(request)")
    }
    func lmrequest(_ request: SKRequest, didFailWithError error: any Error) {
        lmPrint("苹果支付：requestDidFailWithError：\(request), error:\(error)")
        payComplete(error: LMError(code: 999, message: error.localizedDescription))
    }
}
extension ApplePayService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                lmPrint("苹果支付：支付成功 transaction:\(transaction)")
                self.payFinish(transaction)
            case .purchasing:
                lmPrint("苹果支付：商品添加进支付队列 transaction:\(transaction)")
            case .restored:
                lmPrint("苹果支付：已经购买过该商品 transaction:\(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
                payComplete(error: LMError(code: 999, message: "支付失败"))
            case .failed:
                lmPrint("苹果支付：支付失败 transaction:\(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
                payComplete(error: LMError(code: 999, message: "支付失败"))
                default:
                payComplete(error: LMError(code: 999, message: "支付失败"))
            }
        }
    }
}
