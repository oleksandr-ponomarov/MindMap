
import UIKit

protocol MapsListViewType: AnyObject {
    func updateUI()
}

final class MapsListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: MapsListPresenterType?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configureUI()
    }
}

// MARK: - MapsListViewType
extension MapsListViewController: MapsListViewType {
    func updateUI() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MapsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: MapCell.self, for: indexPath)
        let title = presenter?.getCellTitle(at: indexPath)
        cell.setup(title: title)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MapsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapMapCell(at: indexPath)
    }
}

// MARK: - Private methods
private extension MapsListViewController {
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MapCell.self)
        configureNavigationController()
    }
    
    func configureNavigationController() {
        let addMapButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNewMapAlert))
        navigationItem.rightBarButtonItem = addMapButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc func showAddNewMapAlert() {
        presenter?.addNewMapAction()
    }
}

#if targetEnvironment(simulator)
import SwiftUI

@available(iOS 15, *)
struct MapsListViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        Group {
            UIKitControllerPreview {
                let viewController = MapsListViewController()
                let configurator = MapsListConfigurator()
                configurator.configure(viewController: viewController)
                return viewController
            }
        }
    }
}
#endif
