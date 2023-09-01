//
//  AddReading.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/3/22.
//

import SwiftUI
import UIKit

struct AddReading: View {
    @EnvironmentObject var model: UserViewModel
    
    @State var bookTitle: String
    @State var firstPage: Int = 0
    @State var lastPage: Int = 0
    @State var synopsis: String
    @State var formatt: Formatt
    @State var image: Image?
    @State var inputImage: UIImage?
    
    @State var showingSearchResults = false
    @State var showingSearchAlert = false
    @State var searchResultsTitle = ""
    @State var searchResultsMessage = ""
    @State var searchResults = 0
    @State var searchArray = [String]()
    
    @State var showingImageSelector = false
    @State var showingImagePicker = false
    @State var showingCameraPicker = false
    @State var showingDownloadPage = false
    
    var body: some View {
        Form {
            Section {
                Picker("Formato", selection: $formatt) {
                    ForEach(Formatt.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Título del libro", text: $bookTitle)
                    .onSubmit { searchForExistingData(formatt, bookTitle) }
            }
            
            Section {
                HStack {
                    Text("Página inicial")
                    Spacer()
                    TextField("Página inicial", value: $firstPage, format: .number)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Página final")
                    Spacer()
                    TextField("Página inicial", value: $lastPage, format: .number)
                        .multilineTextAlignment(.trailing)
                }
            }
            .keyboardType(.numberPad)
            
            Section("Resumen") {
                TextEditor(text: $synopsis)
                    .frame(width: 350, height: 200)
                VStack {
                    Button("Añadir portada") {
                        showingImageSelector = true
                    }
                    .buttonStyle(.borderless)
                    
                    
                    if let image = image {
                        image
                            .resizable()
                            .frame(width: 100, height: 140)
                    } else {
                        Image(systemName: "questionmark.diamond")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                }
            }
        }
		.modifier(AddReadingModifier(bookTitle: $bookTitle, inputImage: $inputImage, showingSearchResults: $showingSearchResults, showingSearchAlert: $showingSearchAlert, showingImageSelector: $showingImageSelector, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingDownloadPage: $showingDownloadPage, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, isDisabled: isDisabled, loadImage: loadImage, createNewBook: createNewBook))
    }
}

struct AddReading_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddReading(bookTitle: "", synopsis: "", formatt: .paper)
                .environmentObject(UserViewModel())
        }
    }
}
