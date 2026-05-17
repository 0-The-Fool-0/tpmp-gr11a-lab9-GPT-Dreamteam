//
//  ExchangeRateService.swift
//  BankApp
//

import CoreData
import Foundation

final class ExchangeRateService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchRates() -> [RateItem] {
        var items: [RateItem] = []
        context.performAndWait {
            let request = ExchangeRate.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "currencyCode", ascending: true)]
            let rates = (try? context.fetch(request)) ?? []
            items = rates.map { rate in
                RateItem(
                    id: rate.currencyCode ?? UUID().uuidString,
                    currencyCode: rate.currencyCode ?? "",
                    buyRate: rate.buyRate,
                    updatedAt: rate.updatedAt ?? Date()
                )
            }
        }
        return items
    }
}
