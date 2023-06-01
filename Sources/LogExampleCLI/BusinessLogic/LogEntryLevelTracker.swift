struct LogEntryLevelTracker {
  private(set) var traceCount = 0
  private(set) var debugCount = 0
  private(set) var infoCount = 0
  private(set) var noticeCount = 0
  private(set) var warningCount = 0
  private(set) var errorCount = 0
  private(set) var criticalCount = 0

  mutating func track(_ entry: LogEntry) {
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
}
