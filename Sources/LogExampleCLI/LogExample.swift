import ArgumentParser

@main
struct LogExample: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: nil,
    abstract:
      "Log Example will create test log files and help you analyze them to understand the performance implications of different methods",
    version: "1.0.0",
    subcommands: [
      GenerateLogs.self
    ]
  )
}
