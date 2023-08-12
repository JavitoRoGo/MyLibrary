//
//  ChangingBooks.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/12/22.
//

import SwiftUI

struct ChangeBooksOwner: View {
    @State var format: BookFormat = .book
    
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    
    @State var showingAlert = false
    @State var oldOwner = ""
    @State var newOwner = ""
    
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
			.modifier(ChangeOwnerModifier(showingAlert: $showingAlert, format: format, oldOwner: oldOwner, newOwner: newOwner, number: number))
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
