#!/usr/bin/env swift

import Foundation

func getHelp() {
    let commands = [
        "help": "Show this message",
        "get <uri>": "Show app bundle associated with a given URL scheme",
        "getall <uri>": "Show all possible bundles to associate with the given URL scheme"
    ]

    print("Usage:")
    for (cmd, descr) in commands {
        print("\t\(CommandLine.arguments[0]) \(cmd)")
        print("\t\t-> \(descr)")
        print("")
    }
}

func getBundleName(for scheme: String) {
    let defaultHandler = LSCopyDefaultHandlerForURLScheme(scheme as CFString)
    if let bundleName = defaultHandler?.takeRetainedValue() {
        print(bundleName)
    } else {
        print("Invalid URI: \(scheme)")
    }
}

func getHandlers(for scheme: String) -> [String]? {
    let defaultHandlers = LSCopyAllHandlersForURLScheme(scheme as CFString)
    return defaultHandlers?.takeRetainedValue() as? [String]
}

@available(macOS 10.10, *)
func setHandler(for scheme: String, as appName: String) {
    var bundleIdentifier: String? = nil

    // Match `appName' argument with a bundle identifier
    let bundleInfo = LSCopyApplicationURLsForBundleIdentifier(appName as CFString, nil)
    if bundleInfo != nil {
        bundleIdentifier = appName
    } else {
        // Places to look the app for
        let possiblePaths = [
            "/Applications/\(appName)",
            "/Applications/\(appName).app",
            "~/Applications/\(appName)",
            "~/Applications/\(appName).app"
        ]

        // Look for the app
        for p in possiblePaths {
            if let bundle = Bundle(path: p) {
                bundleIdentifier = bundle.bundleIdentifier
                break
            }
        }
    }

    // Check something has been matched
    if bundleIdentifier == nil {
        print("No matching application found for \"\(appName)\"")
        exit(1)
    }

    // Match bundle identifier with a registered app for the URL scheme
    if let handlersArray = getHandlers(for: scheme) {
        if handlersArray.contains(bundleIdentifier!) {
            LSSetDefaultHandlerForURLScheme(scheme as CFString, bundleIdentifier! as CFString)
        } else {
            print("Application \(appName) exists but is not a valid handler for scheme \(scheme)")
            exit(1)
        }
    }
}

/* Main */

if CommandLine.argc == 1 {
    getHelp()
    exit(1)
}

switch CommandLine.arguments[1] {
case "get" where CommandLine.argc == 3:
    // Print name for scheme in argument
    getBundleName(for: CommandLine.arguments[2])
case "set" where CommandLine.argc == 4:
    // Set the handler for a given scheme
    if #available(macOS 10.10, *) {
        setHandler(for: CommandLine.arguments[2], as: CommandLine.arguments[3])
    } else {
        print("This feature is for macOS 10.10+ only.")
        exit(1)
    }
case "getall" where CommandLine.argc == 3:
    // Print all possible handlers for a given scheme
    if let handlers = getHandlers(for: CommandLine.arguments[2]) {
        for handler in handlers {
            print(handler)
        }
    } else {
        print("No handler for \(CommandLine.arguments[2])")
    }
case "help":
    getHelp()
default:
    getHelp()
    exit(1)
}
