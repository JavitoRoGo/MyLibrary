//
//  EditOwners.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/12/22.
//

import SwiftUI

struct EditOwners: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    
    @State private var oldOwner = ""
    @State private var newOwner = ""
    @State private var showingAddOwner = false
    @State private var showingEditOwner = false
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Gestiona aquí los propietarios de los libros y ebooks")
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                List {
                    Section {
                        ForEach(model.myOwners, id: \.self) { owner in
                            NavigationLink {
                                VStack {
                                    Text("Cambia aquí el nombre de esta persona:")
                                    TextField(owner, text: $newOwner)
                                        .padding()
                                        .textFieldStyle(.roundedBorder)
                                    Spacer()
                                }
                                .toolbar {
                                    Button("Modificar") {
                                        if let index = model.myOwners.firstIndex(of: owner) {
                                            model.myOwners[index] = newOwner
                                            if bmodel.numByOwner(owner) != 0 || emodel.numByOwner(owner) != 0 {
                                                oldOwner = owner
                                                showingEditAlert = true
                                            }
                                        }
                                    }
                                    .disabled(newOwner.isEmpty)
                                }
                            } label: {
                                Text(owner)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        if bmodel.numByOwner(owner) == 0 && emodel.numByOwner(owner) == 0 {
                                            model.myOwners.removeAll(where: { $0 == owner })
                                        } else {
                                            oldOwner = owner
                                            showingDeleteAlert = true
                                        }
                                    }
                                } label: {
                                    Label("Borrar", systemImage: "trash")
                                }
                            }
                        }
                        .onMove(perform: move)
                    } header: {
                        Text("Propietarios creados")
                    } footer: {
                        Text("Se muestran los nombres de los propietarios creados. Pulsa sobre un nombre para editarlo o desliza para borrarlo.")
                    }
                    Section {
                        ForEach(bmodel.getSuggestedOwnersFromData(), id:\.self) { owner in
                            Button {
                                model.myOwners.append(owner)
                            } label: {
                                Text(owner)
                            }
                            .disabled(model.myOwners.contains(owner))
                        }
                    } header: {
                        Text("Sugerencias")
                    } footer: {
                        Text("Se muestran sugerencias de nombres de propietarios basadas en la base de datos de libros y ebooks. Pulsa sobre un nombre para añadirlo.")
                    }
                }
                .toolbar {
                    EditButton()
                        .disabled(showingAddOwner || showingEditOwner)
                }
                .alert("Esta persona tiene libros o ebooks registrados.\n¿Deseas borrarla de todas formas?", isPresented: $showingDeleteAlert) {
                    Button("No", role: .cancel) { }
                    Button("Sí", role: .destructive) {
                        model.myOwners.removeAll(where: { $0 == oldOwner })
                        bmodel.changeOwnerFromTo(from: oldOwner, to: "sin asignar")
                        emodel.changeOwnerFromTo(from: oldOwner, to: "sin asignar")
                        oldOwner = ""
                    }
                } message: {
                    Text("Esto NO borrará los libros o ebooks registrados.")
                }
                .alert("Se ha modificado el nombre de esta persona.", isPresented: $showingEditAlert) {
                    Button("No", role: .cancel) { }
                    Button("Sí") {
                        bmodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                        emodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                        newOwner = ""
                    }
                } message: {
                    Text("¿Quieres cambiar también el propietario en todos los registros?")
                }
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
                            model.myOwners.append(newOwner)
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
        .disableAutocorrection(true)
        .navigationTitle("Propietarios")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button() {
                    showingAddOwner = true
                } label: {
                    Label("Añadir", systemImage: "plus")
                }
                .disabled(showingAddOwner || showingEditOwner)
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.myOwners.move(fromOffsets: source, toOffset: destination)
    }
}

struct EditOwners_Previews: PreviewProvider {
    static var previews: some View {
        EditOwners()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
            .environmentObject(EbooksModel())
    }
}
