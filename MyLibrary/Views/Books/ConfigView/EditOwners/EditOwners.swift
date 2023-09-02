//
//  EditOwners.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/12/22.
//

import SwiftUI

struct EditOwners: View {
    @EnvironmentObject var model: UserViewModel
    
    @State var oldOwner = ""
    @State var newOwner = ""
    @State var showingAddOwner = false
    @State var showingEditOwner = false
    @State var showingDeleteAlert = false
    @State var showingEditAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Gestiona aquí los propietarios de los libros y ebooks")
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                List {
                    ownersSection
                    Section {
                        ForEach(model.getSuggestedOwnersFromData(), id:\.self) { owner in
                            Button {
								model.user.myOwners.append(owner)
                            } label: {
                                Text(owner)
                            }
							.disabled(model.user.myOwners.contains(owner))
                        }
                    } header: {
                        Text("Sugerencias")
                    } footer: {
                        Text("Se muestran sugerencias de nombres de propietarios basadas en la base de datos de libros y ebooks. Pulsa sobre un nombre para añadirlo.")
                    }
                }
				.modifier(OwnersListModifier(oldOwner: $oldOwner, newOwner: $newOwner, showingAddOwner: $showingAddOwner, showingEditOwner: $showingEditOwner, showingDeleteAlert: $showingDeleteAlert, showingEditAlert: $showingEditAlert))
            }
            
            if showingAddOwner {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                VStack {
                    TextField("Introduce el nombre del nuevo propietario", text: $newOwner)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    HStack(spacing: 90) {
                        Button("Cancelar", role: .cancel) {
                            newOwner = ""
                            showingAddOwner = false
                        }
                        .buttonStyle(.bordered)
                        Button("Añadir") {
							model.user.myOwners.append(newOwner)
                            newOwner = ""
                            showingAddOwner = false
                        }
                        .buttonStyle(.bordered)
                        .disabled(newOwner.isEmpty)
                    }
                    Spacer()
                }
            }
        }
		.modifier(EditOwnersModifier(showingAddOwner: $showingAddOwner, showingEditOwner: $showingEditOwner))
    }
}

struct EditOwners_Previews: PreviewProvider {
    static var previews: some View {
        EditOwners()
            .environmentObject(UserViewModel())
    }
}
