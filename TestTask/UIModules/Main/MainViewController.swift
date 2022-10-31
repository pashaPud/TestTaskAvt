import UIKit

class MainViewController: UIViewController {
    private var viewModel: MainViewModel!
    let tableView = MainView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var strLabel = UILabel()
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        viewModel = MainViewModel()
        checkConnection()
        super.viewDidLoad()
        setActivityIndicator()
        initView()
        setUpTableView()
        setUpData()
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpTableView() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.alwaysBounceVertical = true
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setRefreshControler()
        tableView.refreshControler.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        checkConnection()
        setUpData()
    }
    
    func setUpData() {
        viewModel.getList {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.refreshControler.endRefreshing()
        }
    }
    
    func checkConnection() {
        if NetworkMonitor.shared.isConnected {
            return
        } else {
            networkAllert()
        }
    }
    
    func networkAllert() {
        let networkAlert = UIAlertController(title: "No connection", message: "looks like you have no internet :c", preferredStyle: .alert)
        networkAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] action in
            self?.viewDidLoad()
        }))
        networkAlert.addAction(UIAlertAction(title: "Show last data", style: .default, handler: { action in
            self.tableView.refreshControler.endRefreshing()
            self.viewModel.getOfflineList {
                self.tableView.reloadData()
            }
        }))
        present(networkAlert, animated: true)
    }
    
    private func setActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.layer.zPosition = 1
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
        } else {
            DispatchQueue.main.async {
                self.networkAllert()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.viewModel = MainTableViewCellViewModel(employee: viewModel.employees[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

