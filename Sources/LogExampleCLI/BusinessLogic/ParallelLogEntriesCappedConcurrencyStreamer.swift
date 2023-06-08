import Files
import Foundation

struct ParallelLogEntriesCappedConcurrencyStreamer {
  private let maxConcurrentTasks = ProcessInfo.processInfo.activeProcessorCount

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
