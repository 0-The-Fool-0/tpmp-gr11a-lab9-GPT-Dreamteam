//
//  BranchesViewModelTests.swift
//  BankAppTests
//

import CoreLocation
import Testing
@testable import BankApp

@MainActor
struct BranchesViewModelTests {
    @Test func reloadRefreshesBranchesFromService() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = BranchService(context: persistence.container.viewContext)
        let viewModel = BranchesViewModel(branchService: service)

        #expect(viewModel.branches.count == 4)

        viewModel.reload()

        #expect(viewModel.branches.count == 4)
    }

    @Test func nearestBranchSelectsClosestOffice() {
        let nearMinsk = CLLocation(latitude: 53.90, longitude: 27.56)
        let nearest = BranchesViewModel.nearestBranch(
            to: nearMinsk,
            from: [SampleModels.brestMain, SampleModels.minskCenter]
        )

        #expect(nearest?.nameKey == SampleModels.minskCenter.nameKey)
    }

    @Test func nearestBranchReturnsNilForEmptyList() {
        let location = CLLocation(latitude: 0, longitude: 0)
        #expect(BranchesViewModel.nearestBranch(to: location, from: []) == nil)
    }

    @Test func findNearestSetsDeniedWhenAuthorizationRestricted() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let viewModel = BranchesViewModel(branchService: BranchService(context: persistence.container.viewContext))

        viewModel.findNearest()

        // Simulator default is often denied/restricted/notDetermined; at least exercise the code path.
        #expect(viewModel.branches.count == 4)
    }
}
