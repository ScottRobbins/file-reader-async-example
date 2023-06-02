import ArgumentParser

struct AnalyzeSynchronously: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "analyze-sync",
    abstract: "Will count the number of logs for each level"
  )

  @Option(
    help: .init(
      "The path to the folder where the log files are located"
    )
  )
  var path: String

  func run() throws {
    var tracker = LogEntryLevelTracker()

    let entries = try SynchronousLogEntriesLoader().loadEntries(atPath: path)

    for entry in entries {
      tracker.track(entry)
    }

    AnalysisDisplayer().display(with: tracker)
  }
}
