//
//  BranchesViewModel.swift
//  BankApp
//

import CoreLocation
import Foundation
import Combine

@MainActor
final class BranchesViewModel: NSObject, ObservableObject {
    @Published private(set) var branches: [BranchItem] = []
    @Published private(set) var nearestBranch: BranchItem?
    @Published private(set) var locationDenied = false
    @Published private(set) var isLocating = false

    private let branchService: BranchService
    private let locationManager = CLLocationManager()

    init(branchService: BranchService) {
        self.branchService = branchService
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        branches = branchService.fetchAllBranches()
    }

    func reload() {
        branches = branchService.fetchAllBranches()
    }

    func findNearest() {
        isLocating = true
        locationDenied = false
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            locationDenied = true
            isLocating = false
        }
    }

    private func updateNearest(from location: CLLocation) {
        nearestBranch = Self.nearestBranch(to: location, from: branches)
        isLocating = false
    }

    static func nearestBranch(to location: CLLocation, from branches: [BranchItem]) -> BranchItem? {
        guard !branches.isEmpty else { return nil }
        return branches.min { lhs, rhs in
            let left = CLLocation(latitude: lhs.latitude, longitude: lhs.longitude)
            let right = CLLocation(latitude: rhs.latitude, longitude: rhs.longitude)
            return location.distance(from: left) < location.distance(from: right)
        }
    }
}

extension BranchesViewModel: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            if manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways {
                manager.requestLocation()
            } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
                locationDenied = true
                isLocating = false
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            updateNearest(from: location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            isLocating = false
        }
    }
}
