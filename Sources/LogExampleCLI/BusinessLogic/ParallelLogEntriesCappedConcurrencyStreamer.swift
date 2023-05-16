import Files
import Foundation

struct ParallelLogEntriesCappedConcurrencyStreamer {
  private let maxConcurrentTasks = 10

  func loadEntries(atPath path: String) -> AsyncStream<LogEntry> {
    return AsyncStream<LogEntry> { continuation in
      Task {
        let folder = try Folder(path: path)

        try await withThrowingTaskGroup(of: Void.self) { group in
          var taskCounter = 0
          for file in folder.files {
            if taskCounter > maxConcurrentTasks {
              let _ = try await group.next()
            }

            taskCounter += 1
            group.addTask {
              let fileString = try file.readAsString()
              let entryStrings = fileString.split(
                whereSeparator: \.isNewline
              )
              let entryDatas = entryStrings.compactMap { $0.data(using: .utf8) }

              let decoder = JSONDecoder()
              decoder.dateDecodingStrategy = .iso8601
              for entryData in entryDatas {
                let entry = try decoder.decode(LogEntry.self, from: entryData)
                continuation.yield(entry)
              }
            }
          }
        }

        continuation.finish()
      }
    }
  }
}
