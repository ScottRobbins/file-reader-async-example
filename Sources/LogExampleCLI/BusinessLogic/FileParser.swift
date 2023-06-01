import Files
import Foundation

struct FileParser {
  func parse(_ file: File) throws -> [LogEntry] {
    let fileString = try file.readAsString()
    let entryStrings = fileString.split(
      whereSeparator: \.isNewline
    )
    let entryDatas = entryStrings.compactMap { $0.data(using: .utf8) }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try entryDatas.map { try decoder.decode(LogEntry.self, from: $0) }
  }
}
