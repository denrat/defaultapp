let cmdname = CommandLine.arguments[0]

// Force presence of usage description
// Also, force presence of `resolve()` function which determines what to do from the information
extension DAAction {
    // CLI-specific variables
    static let subcommandNames: [String]
    static let help: String

    // Classes are instanciated with the remaining arguments as an Array
    init(_ args: ArraySlice<String>)

    // Classes must each implement their resolving
    func resolve()
}

// Register possible actions
// Allows to iter through static properties
let allActions = [
    DAHelper.self,
    DALooker.self,
    DAGetter.self,
    DABinder.self,
]

// defaultapp help [...]
class DAHelper : DAAction {
    static let subcommandNames = ["help", "h"]
    static let help = """
    Usage:
    \t\(cmdname) <command> [<args>...]

    Commands:
    \thelp\tShow this page.
    \tget\tRetrieve the application bound to the given scheme or UTI.
    \tbind\tAssociate scheme/UTI to an application.
    \tfile\tRetrieve the given file's UTI.

    Instead of a command, the following can be provided:
    \troutine\tShow basic usage of the app
    """

    // May give help for a specific subcommand
    var subcommand: String?

    init(_ args: ArraySlice<String>) {
        if !args.isEmpty {
            // Give help for subcommand regardless of the other arguments
            subcommand = args.first
        }
    }

    func resolve() {
        // Match the queried subcommand with a registered one
        for action in allActions {
            for name in action.subcommandNames {
                if name == subcommand {
                    print(action.help)
                    return
                }
            }
        }

        // In case nothing was found
        print("Invalid subcommand: \(subcommand)")
        print(help)
        exit(1)
    }
}

// defaultapp file ...
extension DALooker {
    static let subcommandNames = ["file", "f"]
    static let help = """
    Usage:
    \t\(cmdname) file <file>

    Synonym:
    \t\(cmdname) f ...

    Returns the given file UTI and its default associated app.
    """

    init(_ args: ArraySlice<String>) {
        // Only one argument (the file) is allowed
        guard args.count == 1 else {
            if args.count < 1 {
                throw DACliError.tooFewArguments
            } else {
                throw DACliError.tooManyArguments
            }
        }

        file = args.first
    }
}

// defaultapp get ...
extension DAGetter {
    static let subcommandNames = ["get", "g"]
    static let help = """
    Usage:
    \t\(cmdname) get [options] <scheme|uti>
    \t\(cmdname) get [options] --scheme <scheme>
    \t\(cmdname) get [options] --uti    <uti>

    Synonym:
    \t\(cmdname) g ...

    Retrieve the application bound to the given scheme or UTI.
    Without option, the command will infer the argument's nature.

    Options:
    \t--all | -a
    \t\tShow all possible apps associated with the given scheme or UTI.
    \t--all-no-default | -A
    \t\tShow apps that can be associated with the given scheme or UTI, except the default one.
    """

    // Flags
    enum DAGetterCliFlags {
        case showAll
        case noDefault
    }
    var flags: [DAGetterCliFlags]()

    init(_ args: ArraySlice<String>) {
        let argsIterator = args.makeIterator()
        while let arg = argsIterator.next() {
            // Try to parse options, else arguments
            if arg.hasPrefix("--") {
                // Must be a long flag
                switch arg.dropFirst(2) {
                case "all-no-default":
                    flags.append(.noDefault)
                    fallthrough
                case "all":
                    flags.append(.showAll)
                case "scheme":
                    guard let nextArg = argsIterator.next() else {
                        throw DACliError.tooFewArguments
                    }
                    getterNature = .scheme(nextArg)
                case "uti":
                    guard let nextArg = argsIterator.next() else {
                        throw DACliError.tooFewArguments
                    }
                    getterNature = .uti(nextArg)
                default:
                    throw DACliError.unknownFlag(arg)
                }
            } else if arg.hasPrefix("-") {
                // Must be a short flag
                for c in arg.dropFirst() {
                    switch c {
                    case "A":
                        flags.append(.noDefault)
                        fallthrough
                    case "a":
                        flags.append(.showAll)
                    default:
                        throw DACliError.unknownShortFlag(c)
                    }
                }
            } else {
                // Infer whether the value is a scheme or a UTI
                // TODO: move this to the class in Actions.swift?
                if arg.hasPrefix(":") || !args.contains(".") {
                    binderNature = .scheme(arg)
                } else if arg.contains(".") {
                    // It's an UTI
                    binderNature = .uti(arg)
                }
            }
        }
    }

    func resolve() {
        // The handlers will be queried gradually
        var handlers = Set<String>()

        if flags.contains(.showAll) {
            handlers.insert(allHandlers)

            // Remove default from list if necessary
            if flags.contains(.noDefault) {
                handlers.remove(defaultHandler)
            }
        } else {
            // Only query default handler
            handlers.insert(defaultHandler)
        }

        // To stdout
        for handler in allHandlers {
            print(handler)
        }
    }
}

// defaultapp set ...
extension DABinder {
    static let subcommandNames = ["set", "bind", "b"]
    static let help = """
    Usage:
    \t\(cmdname) bind <scheme|uti> <application|bundle identifier>
    \t\(cmdname) bind <scheme|uti> --app <application>
    \t\(cmdname) bind <scheme|uti> --bundle-identifier <bundle identifier>

    Synonyms:
    \t\(cmdname) set ...
    \t\(cmdname) b ...

    Associates the given scheme or UTI to the given application or its bundle identifier.
    As with `\(cmdname) get ...' the nature of the <scheme|uti> argument will be infered unless corresponding flags are passed. See `\(cmdname) help get'.
    """

    init(_ args: ArraySlice<String>) {
        var appOrIdentifier = args.removeLast()
        if args.last == "--app" {
            binderNature = .application(args.removeLast())
        } else if args.last == "--bundle-identifier" {
            binderNature = .bundleIdentifier(args.removeLast())
        }

        super.init(args)
    }

    func resolve() {

    }
}
