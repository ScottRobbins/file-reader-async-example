import Files
import Foundation

struct LogFilesGenerator {
  private let errorEntry = LogEntry(
    timestamp: Date.now, level: .error, message: "Oh no, we ran into an error!")
  private let debugEntry = LogEntry(
    timestamp: Date.now, level: .debug,
    message: "Something happened that's only interesting to developers running locally")
  private let infoEntry = LogEntry(
    timestamp: Date.now, level: .info,
    message: "This is some generally good information about what's happening in the application")
  private let maxConcurrentTasks = 10

  func generateLogFiles(number numFiles: Int, entriesPerFile: Int, to path: String) async throws {
    let folder = try Folder(path: path)

    // Clean up any old files in this folder
    try folder.files.delete()

    try await withThrowingTaskGroup(of: Void.self) { group in
      var taskCounter = 0
      for fileNumber in 0..<numFiles {
        if taskCounter > maxConcurrentTasks {
          let _ = try await group.next()
        }

        taskCounter += 1
        group.addTask {
          try generateLogFile(
            fileNumber: fileNumber, entriesPerFile: entriesPerFile, to: folder)
        }
      }
    }
  }

  private func generateLogFile(fileNumber: Int, entriesPerFile: Int, to folder: Folder) throws {
    let entries = (0..<entriesPerFile).map { index in
      switch index % 3 {
      case 0:
        return errorEntry
      case 1:
        return debugEntry
      case 2:
        return infoEntry
      default:
        fatalError("This should not have happened")
      }
    }

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let entriesJsonStrings = try entries.map { entry in
      let entryData = try encoder.encode(entry)
      return String(decoding: entryData, as: UTF8.self)
    }

    let lineSeparatedEntries = entriesJsonStrings.joined(separator: "\n")
    let lineSeparatedEntriesData = lineSeparatedEntries.data(using: .utf8)
    try folder.createFile(named: "file-\(fileNumber)", contents: lineSeparatedEntriesData)
  }
}
