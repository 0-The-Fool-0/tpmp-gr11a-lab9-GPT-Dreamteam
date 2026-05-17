//
//  BranchesMapView.swift
//  BankApp
//

import MapKit
import SwiftUI

struct BranchesMapView: View {
    @StateObject private var viewModel: BranchesViewModel
    @State private var cameraPosition: MapCameraPosition = .automatic

    init(dependencies: AppDependencies) {
        _viewModel = StateObject(wrappedValue: BranchesViewModel(branchService: dependencies.branchService))
    }

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $cameraPosition) {
                ForEach(viewModel.branches) { branch in
                    Annotation(branch.name, coordinate: CLLocationCoordinate2D(
                        latitude: branch.latitude,
                        longitude: branch.longitude
                    )) {
                        Image(systemName: viewModel.nearestBranch?.id == branch.id ? "mappin.circle.fill" : "mappin.circle")
                            .font(.title)
                            .foregroundStyle(viewModel.nearestBranch?.id == branch.id ? Color.bankPrimary : .secondary)
                    }
                }
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .frame(height: 320)
            .onAppear { fitMapToBranches() }

            VStack(alignment: .leading, spacing: 14) {

                Button(action: viewModel.findNearest) {
                    HStack {
                        if viewModel.isLocating {
                            ProgressView()
                                .tint(.white)
                        }
                        Text("branches.nearest.button")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(Color.bankPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .disabled(viewModel.isLocating)

                if let nearest = viewModel.nearestBranch {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("branches.nearest.result")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        Text(nearest.name)
                            .font(.headline)
                        Text(nearest.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                if viewModel.locationDenied {
                    Text("branches.location.denied")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                ForEach(viewModel.branches) { branch in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(branch.name)
                            .font(.subheadline.weight(.semibold))
                        Text(branch.address)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(18)
        }
        .background(Color.bankCardBackground)
        .navigationTitle("branches.title")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fitMapToBranches() {
        let coordinates = viewModel.branches.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        guard !coordinates.isEmpty else { return }
        let region = MKCoordinateRegion(coordinates: coordinates)
        cameraPosition = .region(region)
    }
}

private extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        let minLat = coordinates.map(\.latitude).min() ?? 0
        let maxLat = coordinates.map(\.latitude).max() ?? 0
        let minLon = coordinates.map(\.longitude).min() ?? 0
        let maxLon = coordinates.map(\.longitude).max() ?? 0
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) * 1.4, 0.08),
            longitudeDelta: max((maxLon - minLon) * 1.4, 0.08)
        )
        self.init(center: center, span: span)
    }
}

#Preview {
    BranchesMapView(dependencies: AppDependencies())
}
