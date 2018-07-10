enum DACommandType {
    case help, get, set, getall, geturi
}

class DAInstance {
    // Diverse information
    var callee: String?

    // Options
    var isSimulation = false
    var isSilent = false

    // Command
    var command: DefaultAppCommandType? = nil {
        willSet(newcmd) {
            guard newcmd == nil || command == nil else {
                // FIXME is this necessary to check this here?
                help()
                exit(1)
            }
        }
    }

    // Computed values
    var result: String? {
        switch command {
        case .help:
            help()
            return nil
        case .get:
        case .set:
        case .getall:
        case .geturi:
        default:
            return nil
        }
    }
}
