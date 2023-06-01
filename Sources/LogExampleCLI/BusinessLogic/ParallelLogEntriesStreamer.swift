import Files

struct ParallelLogEntriesStreamer {
  func loadEntries(atPath path: String) -> AsyncStream<LogEntry> {
    return AsyncStream<LogEntry> { continuation in
      Task {
        let folder = try Folder(path: path)

        await withThrowingTaskGroup(of: Void.self) { group in
          for file in folder.files {
            group.addTask {
              for entry in try FileParser().parse(file) {
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
