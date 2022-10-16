
import SwiftUI

@available(iOS 13, *)
struct UIKitControllerPreview: UIViewControllerRepresentable {
    
    let viewController: UIViewController
    
    init(viewControllerCompletion: () -> UIViewController) {
        viewController = viewControllerCompletion()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
}
