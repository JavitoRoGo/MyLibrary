//
//  UserConfigViewExportingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/9/23.
//

import SwiftUI

extension UserConfigView {
	var exportingButtons: some View {
		Section {
			Button {
				shareAction()
			} label: {
				HStack {
					Image(systemName: "link")
					Text("Compartir datos")
						.foregroundColor(.primary)
				}
			}
			Button {
				isExporting = true
			} label: {
				HStack {
					Image(systemName: "square.and.arrow.up")
					Text("Exportar datos")
						.foregroundColor(.primary)
				}
			}
			Button {
				isImporting = true
			} label: {
				HStack {
					Image(systemName: "square.and.arrow.down")
					Text("Importar datos")
						.foregroundColor(.primary)
				}
			}
		}
	}
}
