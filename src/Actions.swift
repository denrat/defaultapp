import Foundation

protocol DAAction { }

// DALooker: retrieve information about a given file
class DALooker : DAAction {
    var file: String? {
        didSet {
            // Update fileURL from this value

            // Search for the given file
            if file.hasPrefix("/") {
                // Absolute path
            } else {
                // Relative path
            }

            // Turn path into URL
            fileURL = nil
        }
    }
    var fileURL: URL?
    var uti: String? {
        return (fileURL == nil) nil : /* hmmm */;
    }
    var defaultHandler: String? {
        // FIXME return the default bundle identifier for file's UTI
    }
}

// DAGetter: get default application for a given scheme or UTI
class DAGetter : DAAction {
    // Differenciate schemes and UTIs
    enum DAGetterNatureUnion {
        case scheme(Srting)
        case uti(String)
    }
    var getterNature: DAGetterNatureUnion? {
        didSet {
            switch getterNature {
            case .scheme(let scheme):
            case .uti(let uti):
            }
        }
    }

    init(scheme: String) {
        getterNature = .scheme(scheme)
    }

    init(uti: String) {
        getterNature = .uti(uti)
    }

    var defaultHandler: String? {
        switch getterNature {
        case .scheme(let scheme):
            return LSCopyDefaultHandlerForURLScheme(scheme as CFString)?.takeRetainedValue() as? String
        case .uti(let uti):
            return LSCopyDefaultRoleHandlerForContentType(uti as CFString, .all)?.takeRetainedValue() as? String
        }
    }
    var allHandlers: Set<String>? {
        switch getterNature {
        case .scheme(let scheme):
            return LSCopyAllHandlersForURLScheme(self.scheme as CFString)?.takeRetainedValue() as? [String]

        case .uti(let uti):
            if let allRolesHandled = LSCopyAllRoleHandlersForContentType(self.uti as CFString, .all)?.takeRetainedValue() as? [String] {
                if let cantOpen = LSCopyAllRoleHandlersForContentType(self.scheme as CFString, .none)?.takeRetainedValue() as? [String] {
                    return (allRolesHandled as Set).union(cantOpen)
                }
            }
        }
    }
}

// DABinder: Bind a scheme or UTI to the given application
class DABinder : DAGetter {
    enum DABinderNatureUnion {
        case application(String)
        case bundleIdentifier(String)
    }
    var binderNature: DABinderNatureUnion?

    override init(_ schemeOrUTI: String, to targetApp: String) {
        super.init(schemeOrUTI)
        self.targetApp = targetApp
    }

    @available(macOS 10.10, *)
    func bind() {
    }
}
