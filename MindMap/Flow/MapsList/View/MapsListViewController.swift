
import UIKit

protocol MapsListViewType: AnyObject {
    func updateUI()
}

class MapsListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: MapsListPresenterType?
    private var configurator: MapsListConfiguratorType = MapsListConfigurator()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(viewController: self)
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

// MARK: - Private methods
private extension MapsListViewController {
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
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

extension MapsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell else { return .init() }
        let cellData = presenter?.getCellData(by: indexPath) ?? ""
        cell.setupCell(with: cellData)
        cell.selectionStyle = .none
        return cell
    }
}

extension MapsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("AP: Show map screen by index \(indexPath.row)")
        
        presenter?.didTapMapCell(with: indexPath)
    }
}
