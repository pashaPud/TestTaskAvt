import Foundation

final class MainViewModel {
    private let networkClient = NetworkClientImp()
    var employees: [Employee] = []
    var companyName = String()
    func getList(onComplete: @escaping () -> Void) {
        let url = NetworkConstants.testEndpoint
        networkClient.getData(url: url!) {[weak self] (model: Employees) in
            self?.employees = model.company.employees.sorted { $0.name < $1.name}
            self?.companyName = model.company.name
            DispatchQueue.main.async {
                onComplete()
            }
        }
    }

    func getOfflineList(onComplete: @escaping () -> Void) {
        networkClient.fetchUserDefaultsData(key: UserDefaultsConstants.avitoData) { [weak self] (model: Employees) in
            self?.employees = model.company.employees.sorted { $0.name < $1.name}
            DispatchQueue.main.async {
                onComplete()
            }
        }
    }
}
