//
//  EditRDMapViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/10/23.
//

import MapKit
import SwiftUI

extension EditRDMapView {
	var locationButtons: some View {
		VStack {
			Button {
				let userLocation = manager.userLocation
				location = RDLocation(id: UUID(), latitude: userLocation.latitude, longitude: userLocation.longitude)
				dismiss()
			} label: {
				Text("Elegir mi ubicación")
					.frame(width: 250)
			}
			.disabled(!manager.userPermission)
			Button {
				if let mapLocation = visibleRegion?.center, myMarkerCoordinate != nil {
					location = RDLocation(id: UUID(), latitude: mapLocation.latitude, longitude: mapLocation.longitude)
					dismiss()
				}
			} label: {
				Text("Elegir marcador")
					.frame(width: 250)
			}
			.disabled(myMarkerCoordinate == nil)
			Button {
				if let mapLocation = visibleRegion?.center {
					myMarkerCoordinate = CLLocationCoordinate2D(latitude: mapLocation.latitude, longitude: mapLocation.longitude)
				}
			} label: {
				Text("Añadir marcador")
					.frame(width: 250)
			}
			.buttonStyle(.bordered)
			Text("Puedes elegir entre tu ubicación actual o cualquier otra ubicación en el mapa añadiendo un marcador.")
				.font(.caption)
				.foregroundColor(.secondary)
				.padding(.horizontal)
		}
		.buttonStyle(.borderedProminent)
		.padding(.top)
		.overlay(alignment: .topTrailing) {
			Button {
				dismiss()
			} label: {
				Image(systemName: "xmark.circle.fill")
					.font(.title3)
					.foregroundStyle(.secondary)
			}
			.buttonStyle(.plain)
		}
		.frame(maxWidth: .infinity)
		.background(.ultraThinMaterial)
	}
	
	var mapStyleButton: some View {
		HStack {
			Button {
				withAnimation(.spring) {
					showingMapStyleOptions.toggle()
				}
			} label: {
				Image(systemName: "map")
					.font(.title3)
					.foregroundStyle(.white)
					.padding(12)
					.background(.orange)
					.clipShape(.circle)
			}
			if showingMapStyleOptions {
				Button {
					withAnimation(.easeInOut) {
						customMapStyle = .standard(elevation: .realistic)
						showingMapStyleOptions.toggle()
					}
				} label: {
					Text("Por defecto")
						.font(.caption)
						.foregroundStyle(.white)
						.padding(7)
						.background(.gray)
						.clipShape(.rect(cornerRadius: 12))
				}
				Button {
					withAnimation(.easeInOut) {
						customMapStyle = .imagery(elevation: .realistic)
						showingMapStyleOptions.toggle()
					}
				} label: {
					Text("Satélite")
						.font(.caption)
						.foregroundStyle(.white)
						.padding(7)
						.background(.gray)
						.clipShape(.rect(cornerRadius: 12))
				}
			}
		}
		.buttonStyle(.plain)
		.offset(x: 20, y: 15)
	}
}
