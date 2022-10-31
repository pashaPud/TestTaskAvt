import Foundation
protocol NetworkClient {
   func getData<T: Codable>(url: URL, onComplete: @escaping (T) -> Void)
}
