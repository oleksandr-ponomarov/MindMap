
import UIKit

protocol MapsListViewType: AnyObject {
    
}

class MapsListViewController: UIViewController {
    
    var presenter: MapsListPresenterType?
    private var configurator: MapsListConfiguratorType = MapsListConfigurator()
    
    @IBOutlet private weak var tableView: UITableView!
    
    var mapsArray: [String] = []
    
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
    }
    
    @objc func showAddNewMapAlert() {
        let alert = UIAlertController(title: "Hi", message: "Enter name your new map:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "enter map name"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            self.mapsArray.append("New map")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mapsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell else { return .init() }
        cell.setupCell(with: "\(mapsArray[indexPath.row])")
        return cell
    }
}

extension MapsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("AP: Show map screen by index \(indexPath.row)")
    }
}
