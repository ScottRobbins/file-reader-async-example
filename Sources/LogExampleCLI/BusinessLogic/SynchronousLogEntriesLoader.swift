import Files

struct SynchronousLogEntriesLoader {
  func loadEntries(atPath path: String) throws -> [LogEntry] {
    let folder = try Folder(path: path)

    var entries = [LogEntry]()
    for file in folder.files {
      let newEntries = try FileParser().parse(file)
      entries.append(contentsOf: newEntries)
    }

    return entries
  }
}
