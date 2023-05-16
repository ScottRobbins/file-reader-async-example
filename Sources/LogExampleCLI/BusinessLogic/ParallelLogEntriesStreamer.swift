import Files
import Foundation

struct ParallelLogEntriesStreamer {
  func loadEntries(atPath path: String) -> AsyncStream<LogEntry> {
    return AsyncStream<LogEntry> { continuation in
      Task {
        let folder = try Folder(path: path)

        await withThrowingTaskGroup(of: Void.self) { group in
          for file in folder.files {
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
