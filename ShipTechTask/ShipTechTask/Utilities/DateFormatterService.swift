import Foundation

final class DateFormatterService {
    static let shared = DateFormatterService()

    private let dateFormatter: DateFormatter

    private init() {
        dateFormatter = DateFormatter()
    }

    func formatYear(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}
