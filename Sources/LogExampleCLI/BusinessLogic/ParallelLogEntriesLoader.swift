import Files
import Foundation

actor LogEntriesContainer {
  var logEntries: [LogEntry] = []

  func append(contentsOf entries: [LogEntry]) {
    logEntries.append(contentsOf: entries)
  }
}

struct ParallelLogEntriesLoader {
  func loadEntries(atPath path: String) async throws -> [LogEntry] {
    let folder = try Folder(path: path)

    let container = LogEntriesContainer()
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
          let newEntries = try entryDatas.map { try decoder.decode(LogEntry.self, from: $0) }
          await container.append(contentsOf: newEntries)
        }
      }
    }

    return await container.logEntries
  }
}
