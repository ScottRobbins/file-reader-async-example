import ArgumentParser

struct GenerateLogs: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "generate",
    abstract: "Will generate log files"
  )

  @Option(
    help: .init(
      "The number of log files you'd like to create"
    )
  )
  var numFiles: Int

  @Option(
    help: .init(
      "The number of log entries to put in a file"
    )
  )
  var numEntriesPerFile: Int

  @Option(
    help: .init(
      "The path to the folder you would like to save these files in"
    )
  )
  var path: String

  func run() async throws {
    try await LogFilesGenerator().generateLogFiles(
      number: numFiles, entriesPerFile: numEntriesPerFile, to: path)
  }
}
