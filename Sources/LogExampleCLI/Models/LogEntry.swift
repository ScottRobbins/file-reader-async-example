import Foundation

struct LogEntry: Codable {
  let timestamp: Date
  let level: LogLevel
  let message: String
}
