//
//  AuthService.swift
//  BankApp
//

import CoreData
import Foundation

final class AuthService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func validate(login: String, password: String) -> UserSession? {
        var result: UserSession?
        context.performAndWait {
            let request = User.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "login == %@ AND password == %@", login, password)
            guard let user = try? context.fetch(request).first,
                  let id = user.id else { return }
            result = UserSession(id: id, login: user.login ?? login, displayName: user.displayName ?? "")
        }
        return result
    }
}
