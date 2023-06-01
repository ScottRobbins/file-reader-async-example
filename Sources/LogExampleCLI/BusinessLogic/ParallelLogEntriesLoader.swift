import Files

struct ParallelLogEntriesLoader {
  func loadEntries(atPath path: String) async throws -> [LogEntry] {
    let folder = try Folder(path: path)

    return try await withThrowingTaskGroup(of: [LogEntry].self) {
      group in
      for file in folder.files {
        group.addTask {
          return try FileParser().parse(file)
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
