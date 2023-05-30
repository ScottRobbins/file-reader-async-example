import Files
import Foundation

struct ParallelLogEntriesLoader {
  func loadEntries(atPath path: String) async throws -> [LogEntry] {
    let folder = try Folder(path: path)

    return try await withThrowingTaskGroup(of: [LogEntry].self) {
      group in
      for file in folder.files {
        group.addTask {
          let fileString = try file.readAsString()
          let entryStrings = fileString.split(
            whereSeparator: \.isNewline
          )
          let entryDatas = entryStrings.compactMap { $0.data(using: .utf8) }

          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          let newEntries = try entryDatas.map { try decoder.decode(LogEntry.self, from: $0) }
          return newEntries
        }
      }

      var logEntries = [LogEntry]()
      for try await entries in group {
        logEntries.append(contentsOf: entries)
      }

      return logEntries
    }
  }
}
