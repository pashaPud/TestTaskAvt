import Foundation

final class MainTableViewCellViewModel {
    var name = ""
    var skills: [String] = []
    var phoneNumber = ""
    private let employee: Employee
    init(employee: Employee) {
        self.employee = employee
        setUpBindings()
    }

    private func setUpBindings() {
        self.name = employee.name
        self.skills = employee.skills
        self.phoneNumber = employee.phoneNumber
    }
}
