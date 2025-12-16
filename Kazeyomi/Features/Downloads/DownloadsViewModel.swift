import Foundation
import Observation

@MainActor
@Observable
final class DownloadsViewModel {
    struct Summary: Equatable {
        let state: String
        let queued: Int
        let downloading: Int
        let finished: Int
        let error: Int
        let total: Int
    }

    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var summary: Summary?

    func load(serverSettings: ServerSettingsStore) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let client = TachideskClient(serverSettings: serverSettings)
            let status = try await client.downloadStatus()

            let counts = Dictionary(grouping: status.queue, by: { $0.state })
            let queued = counts["QUEUED"]?.count ?? 0
            let downloading = counts["DOWNLOADING"]?.count ?? 0
            let finished = counts["FINISHED"]?.count ?? 0
            let error = counts["ERROR"]?.count ?? 0
            let total = status.queue.count

            summary = Summary(
                state: status.state,
                queued: queued,
                downloading: downloading,
                finished: finished,
                error: error,
                total: total
            )
        } catch {
            summary = nil
            errorMessage = error.localizedDescription
        }
    }
}
