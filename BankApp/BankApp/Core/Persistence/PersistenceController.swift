//
//  PersistenceController.swift
//  BankApp
//

import CoreData

/// Core Data stack backed by SQLite (`NSSQLiteStoreType`).
struct PersistenceController {
    static let shared = PersistenceController()

    /// Single in-memory stack for `-UITesting` launches.
    static let testing = PersistenceController(inMemory: true)

    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        return controller
    }()

    static var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    private static let managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: CoreDataBundleMarker.self)
        let modelURL = bundle.url(forResource: "BankApp", withExtension: "momd")
            ?? bundle.url(forResource: "BankApp", withExtension: "mom")
        guard let modelURL,
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("BankApp Core Data model not found in bundle \(bundle.bundlePath)")
        }
        return model
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(
            name: "BankApp",
            managedObjectModel: Self.managedObjectModel
        )
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let description = container.persistentStoreDescriptions.first
            description?.type = NSSQLiteStoreType
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

private final class CoreDataBundleMarker {}
