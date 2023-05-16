import Files
import Foundation

struct ExampleLogEntriesReader {
  func loadEntries(atPath path: String) throws -> [LogEntry] {
    let folder = try Folder(path: path)

    var entries = [LogEntry]()
    for file in folder.files {
      let fileString = try file.readAsString()
      let entryStrings = fileString.split(
        whereSeparator: \.isNewline
      )
      let entryDatas = entryStrings.compactMap { $0.data(using: .utf8) }

      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let newEntries = try entryDatas.map { try decoder.decode(LogEntry.self, from: $0) }
      entries.append(contentsOf: newEntries)
    }

    return entries
  }
}
