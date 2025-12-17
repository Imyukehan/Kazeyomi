import Foundation

enum SourcePreferenceItem: Identifiable, Hashable {
    case checkBox(
        position: Int,
        key: String,
        title: String,
        summary: String?,
        value: Bool,
        defaultValue: Bool
    )
    case toggle(
        position: Int,
        key: String,
        title: String,
        summary: String?,
        value: Bool,
        defaultValue: Bool
    )
    case list(
        position: Int,
        key: String,
        title: String,
        summary: String?,
        value: String,
        defaultValue: String?,
        entries: [String],
        entryValues: [String]
    )
    case editText(
        position: Int,
        key: String,
        title: String,
        summary: String?,
        value: String,
        defaultValue: String?,
        dialogTitle: String?,
        dialogMessage: String?
    )
    case multiSelect(
        position: Int,
        key: String,
        title: String,
        summary: String?,
        values: [String],
        defaultValues: [String],
        entries: [String],
        entryValues: [String],
        dialogTitle: String?,
        dialogMessage: String?
    )

    var id: String {
        switch self {
        case .checkBox(let position, let key, _, _, _, _),
             .toggle(let position, let key, _, _, _, _),
             .list(let position, let key, _, _, _, _, _, _),
             .editText(let position, let key, _, _, _, _, _, _),
             .multiSelect(let position, let key, _, _, _, _, _, _, _, _):
            return "\(position):\(key)"
        }
    }

    var position: Int {
        switch self {
        case .checkBox(let position, _, _, _, _, _),
             .toggle(let position, _, _, _, _, _),
             .list(let position, _, _, _, _, _, _, _),
             .editText(let position, _, _, _, _, _, _, _),
             .multiSelect(let position, _, _, _, _, _, _, _, _, _):
            return position
        }
    }

    var title: String {
        switch self {
        case .checkBox(_, _, let title, _, _, _),
             .toggle(_, _, let title, _, _, _),
             .list(_, _, let title, _, _, _, _, _),
             .editText(_, _, let title, _, _, _, _, _),
             .multiSelect(_, _, let title, _, _, _, _, _, _, _):
            return title
        }
    }

    var summary: String? {
        switch self {
        case .checkBox(_, _, _, let summary, _, _),
             .toggle(_, _, _, let summary, _, _),
             .list(_, _, _, let summary, _, _, _, _),
             .editText(_, _, _, let summary, _, _, _, _),
             .multiSelect(_, _, _, let summary, _, _, _, _, _, _):
            return summary
        }
    }
}
