import Foundation
final class NetworkClientImp: NetworkClient {

    var lastTimeOfUpdate = UserDefaults.standard.integer(forKey: UserDefaultsConstants.timeOfLastUpdate)

    func getData<T: Codable>(url: URL, onComplete: @escaping (_ model: T) -> Void) {
        if needToUpdate() || lastTimeOfUpdate == 0 {
            fetchNetworkData(url: url) { (model: T) in
                onComplete(model)
            }
        } else {
            fetchUserDefaultsData(key: UserDefaultsConstants.avitoData) { (model: T) in
                onComplete(model)
            }
        }
    }

    func needToUpdate() -> Bool {
        if Int(Date().timeIntervalSince1970) - lastTimeOfUpdate > 10 {
            return true
        } else {
            return false
        }
    }

    func fetchUserDefaultsData<T: Codable>(key: String, onComplete: @escaping (_ model: T) -> Void) {
        let decoder = JSONDecoder()
        let data = UserDefaults.standard.data(forKey: key)
        do {
            let result = try decoder.decode(T.self, from: data!)
            onComplete(result)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchNetworkData<T: Codable>(url: URL, onComplete: @escaping (_ model: T) -> Void) {
        let urlSession = URLSession(configuration: .default)
        let decoder = JSONDecoder()
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.status?.responseType == .success else {
                print(error.debugDescription)
                return
            }
            do {
                let result = try decoder.decode(T.self, from: data)
                UserDefaults.standard.setValue(data, forKey: UserDefaultsConstants.avitoData)
                UserDefaults.standard.setValue(Int(Date().timeIntervalSince1970), forKey: UserDefaultsConstants.timeOfLastUpdate)
                self.lastTimeOfUpdate = UserDefaults.standard.integer(forKey: UserDefaultsConstants.timeOfLastUpdate)
                onComplete(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
