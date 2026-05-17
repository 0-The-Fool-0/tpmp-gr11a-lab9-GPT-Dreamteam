//
//  BranchService.swift
//  BankApp
//

import CoreData
import Foundation

final class BranchService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllBranches() -> [BranchItem] {
        var items: [BranchItem] = []
        context.performAndWait {
            let request = Branch.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "nameKey", ascending: true)]
            let branches = (try? context.fetch(request)) ?? []
            items = branches.compactMap { branch in
                guard let id = branch.id else { return nil }
                return BranchItem(
                    id: id,
                    nameKey: branch.nameKey ?? "",
                    address: branch.address ?? "",
                    latitude: branch.latitude,
                    longitude: branch.longitude
                )
            }
        }
        return items
    }
}
