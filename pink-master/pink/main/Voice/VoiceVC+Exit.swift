import Foundation
extension VoiceVC {
    func exitRoom(complete block: @escaping () -> Void) {
        HUD.showLoading()
        self.viewModel.exitRoom { [weak self] in
            guard let self = self else { return }
            self.clear()
            HUD.hide()
            block()
        }
    }
    private func clear() {
       roomView.clear()
        LMFloatingManager.shared.set_SuperView(nil)
       LMRMWelcomeManager.shared.set_SuperView(nil)
        giftTrackManager.set_SuperView(nil)
    }
}
