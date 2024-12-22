import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "^[A-Za-z0-9А-Яа-яЁё._%+-]+@[A-Za-z0-9А-Яа-яЁё.-]+\\.[A-Za-zА-Яа-яЁё]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
}
