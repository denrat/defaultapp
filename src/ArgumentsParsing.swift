import Foundation

let argv = CommandLine.arguments
let argc = CommandLine.argc

func parseArgs() throws -> DAAction {
    guard argc >= 2 else {
        throw DACliError.tooFewArguments
    }

    // Register subcommands
    var subcommands: [String: DAAction]

    for action in allActions {
        for name in subcommandNames {
            subcommands[name] = action
        }
    }

    // Match subcommand to action
    guard subcommands.contains(argv[1]) else {
        throw DACliError.invalidSubcommand
    }

    let action = subcommands[argv[1]].init(argv[2...])

    return action
}
