import Foundation

/*
 * Manage different types that can be passed to the `get` command
 */

class DocumentIdentifier : String { }

class Scheme : DocumentIdentifier { }
class UTI : DocumentIdentifier { }
class Path : DocumentIdentifier { }

/*
 * Manage different ways to represent an app
 * TODO: don't use it and prefer automatic translation to bundle identifier
 */

class ApplicationIdentifier : String { }

class AppFullNameIdentifier : ApplicationIdentifier { }
class AppShortNameIdentifier : ApplicationIdentifier { }
class AppBundleIdentifier : ApplicationIdentifier { }

/*
 * Represent commands as types
 */

class Help { }

class DefaultAppCommand {
    enum DocumentIdentifierEnum {
        case scheme
        case uti
        case filePath
    }

    // eventually put some parameters here
    var simulation = false
    var documentIdentifierType: DocumentIdentifierEnum

    func determineDocumentIdentifierType(docId: String) {
        // TODO
    }
}

class GetHandlerQuery : DefaultAppCommand {
    // We may want a handler for a Scheme xor a UTI
    let docId: DocumentIdentifier
    init(for docId: DocumentIdentifier) {
        self.docId = docId
    }
}

class GetAllHandlersQuery : GetHandlerQuery { }

class SetHandlerQuery : DefaultAppCommand {
    let docId: DocumentIdentifier
    let app: ApplicationIdentifier

    init(for docId: DocumentIdentifier, with app: ApplicationIdentifier) {
        // Determine the document identifier's nature
        if let path = ... {
            self.docId = Path(path)
        } else if let scheme = ... {
            self.docId = Scheme(scheme)
        } else if let uti = ... {
            self.docId = UTI(uti)
        }

        // Determine the application identifier's nature
        if LSCopyApplicationURLsForBundleIdentifier(app, nil) {
            self.app = AppBundleIdentifier(app)
        } else {
            let possiblePaths = [
                app,
                "/Applications/\(app)",
                "/Applications/\(app).app",
                "~/Applications/\(app)",
                "~/Applications/\(app).app",
            ]

            for path in possiblePaths {
                if let bundle = Bundle(path: path) {
                    self.app = bundle.bundleIdentifier
                }
            }
        }
    }
}
