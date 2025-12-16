import Foundation

enum Timestamps {
    /// Tachidesk uses LongString for timestamps; in practice it may be seconds or milliseconds.
    static func date(fromLongString value: String?) -> Date? {
        guard let value, let raw = Double(value) else { return nil }
        // Heuristic: > 10^11 treated as milliseconds.
        if raw > 100_000_000_000 {
            return Date(timeIntervalSince1970: raw / 1000.0)
        }
        if raw > 0 {
            return Date(timeIntervalSince1970: raw)
        }
        return nil
    }

    static func dayKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func relativeDayTitle(from date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "今天" }
        if calendar.isDateInYesterday(date) { return "昨天" }
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
