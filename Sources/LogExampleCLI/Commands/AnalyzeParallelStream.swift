import ArgumentParser
import Rainbow

struct AnalyzeParallelStream: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "analyze-parallel-stream",
    abstract: "Will count the number of logs for each level"
  )

  @Option(
    help: .init(
      "The path to the folder where the log files are located"
    )
  )
  var path: String

  func run() async throws {
    var tracker = LogEntryLevelTracker()

    let entries = ParallelLogEntriesStreamer().loadEntries(atPath: path)

    for await entry in entries {
      tracker.track(entry)
    }

    AnalysisDisplayer().display(with: tracker)
  }
}
