enum DACliError: Error {
    case invalidSubcommand(subcommand: String)
    case invalidArguments
    case tooFewArguments
    case tooManyArguments
    case unknownFlag(_ flag: String)
    case unknownShortFlag(_ flag: String)
}
