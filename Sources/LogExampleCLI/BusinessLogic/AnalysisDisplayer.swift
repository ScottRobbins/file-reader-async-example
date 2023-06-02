import Rainbow

struct AnalysisDisplayer {
  func display(with logEntryLevelTracker: LogEntryLevelTracker) {
    print("Analysis")
    print("--------")
    print("trace:".blue, "\t\t", logEntryLevelTracker.traceCount)
    print("debug:".green, "\t\t", logEntryLevelTracker.debugCount)
    print("info:", "\t\t", logEntryLevelTracker.infoCount)
    print("notice:".magenta, "\t", logEntryLevelTracker.noticeCount)
    print("warning:".yellow, "\t", logEntryLevelTracker.warningCount)
    print("error:".red, "\t\t", logEntryLevelTracker.errorCount)
    print("critical:".red, "\t", logEntryLevelTracker.criticalCount)
  }
}
