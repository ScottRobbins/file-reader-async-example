import ArgumentParser
import Rainbow

struct AnalyzeExample: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "analyze-example",
    abstract: "Will count the number of logs for each level"
  )

  @Option(
    help: .init(
      "The path to the folder where the log files are located"
    )
  )
  var path: String

  func run() throws {
    var traceCount = 0
    var debugCount = 0
    var infoCount = 0
    var noticeCount = 0
    var warningCount = 0
    var errorCount = 0
    var criticalCount = 0

    let entries = try ExampleLogEntriesReader().loadEntries(atPath: path)

    for entry in entries {
      switch entry.level {
      case .trace:
        traceCount += 1
      case .debug:
        debugCount += 1
      case .info:
        infoCount += 1
      case .notice:
        noticeCount += 1
      case .warning:
        warningCount += 1
      case .error:
        errorCount += 1
      case .critical:
        criticalCount += 1
      }
    }

    print("Analysis")
    print("--------")
    print("trace:".blue, "\t\t", traceCount)
    print("debug:".green, "\t\t", debugCount)
    print("info:", "\t\t", infoCount)
    print("notice:".magenta, "\t", noticeCount)
    print("warning:".yellow, "\t", warningCount)
    print("error:".red, "\t\t", errorCount)
    print("critical:".red, "\t", criticalCount)
  }
}
