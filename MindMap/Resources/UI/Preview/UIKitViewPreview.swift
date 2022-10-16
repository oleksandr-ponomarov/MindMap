
import SwiftUI

struct UIKitViewPreview: UIViewRepresentable {

    let view: UIView
    
    init(viewCompletion: @escaping () -> UIView) {
        view = viewCompletion()
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
