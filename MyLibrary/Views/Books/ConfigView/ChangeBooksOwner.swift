//
//  ChangingBooks.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/12/22.
//

import SwiftUI

struct ChangeBooksOwner: View {
    enum BookFormat: String, CaseIterable {
        case book = "Libros"
        case ebook = "eBooks"
        case all = "Todos"
    }
    @State private var format: BookFormat = .book
    
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    @State private var oldOwner = ""
    @State private var newOwner = ""
    
    var number: Int {
        switch format {
        case .book:
            return bmodel.numByOwner(oldOwner)
        case .ebook:
            return emodel.numByOwner(oldOwner)
        case .all:
            return bmodel.numByOwner(oldOwner) + emodel.numByOwner(oldOwner)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Selecciona la persona de origen y destino para mover todos los registros en bloque.\nElige qué datos deseas cambiar:")
                    .padding()
                    .multilineTextAlignment(.center)
                Picker("Datos", selection: $format) {
                    ForEach(BookFormat.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                VStack {
                    Picker("Origen", selection: $oldOwner) {
                        ForEach(model.myOwners, id: \.self) {
                            Text($0)
                        }
                    }
                    Image(systemName: "arrow.down")
                        .font(.system(size: 50))
                    Picker("Destino", selection: $newOwner) {
                        ForEach(model.myOwners, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Cambio masivo de propietario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mover") {
                        showingAlert.toggle()
                    }
                    .disabled(oldOwner == newOwner || oldOwner.isEmpty || newOwner.isEmpty)
                }
            }
            .alert("Esto cambiará el propietario de \(number) \(format == .all ? "registros" : format.rawValue.lowercased()), de \(oldOwner) a \(newOwner).", isPresented: $showingAlert) {
                Button("No", role: .cancel) { }
                Button("Sí") {
                    switch format {
                    case .book:
                        bmodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                    case .ebook:
                        emodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                    case .all:
                        bmodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                        emodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
                    }
                    dismiss()
                }
            } message: {
                Text("¿Estás seguro?")
            }
        }
    }
}

struct ChangingBooks_Previews: PreviewProvider {
    static var previews: some View {
        ChangeBooksOwner()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
            .environmentObject(EbooksModel())
    }
}
