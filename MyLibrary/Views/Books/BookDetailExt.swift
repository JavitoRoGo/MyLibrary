//
//  BookDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

// Secciones que componen la vista
extension BookDetail {
	var authorSection: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Autor:")
						.font(.subheadline)
					Text(book.author)
						.font(.headline)
				}
				Spacer()
				Button {
					titleInfoAlert = book.status.infoAlert.title
					messageInfoAlert = book.status.infoAlert.message
					showingInfoAlert = true
				} label: {
					Image(systemName: book.status.iconName)
						.font(.title)
						.foregroundColor(book.status.iconColor)
				}
				.buttonStyle(.bordered)
			}
			VStack(alignment: .leading) {
				Text("Título:")
					.font(.subheadline)
				Text(book.bookTitle)
					.font(.headline)
			}
			VStack(alignment: .leading) {
				Text("Título original:")
					.font(.subheadline)
				Text(book.originalTitle)
					.font(.headline)
			}
		}
	}
	
	var publisherSection: some View {
		Section {
			VStack(alignment: .leading) {
				Text("Editorial:")
					.font(.subheadline)
				Text(book.publisher)
					.font(.headline)
			}
			VStack(alignment: .leading) {
				Text("Ciudad:")
					.font(.subheadline)
				Text(book.city)
					.font(.headline)
			}
			HStack {
				VStack {
					Text("Edición:")
						.font(.subheadline)
					Text(book.edition, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Año:")
						.font(.subheadline)
					Text(String(book.editionYear))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Año escritura:")
						.font(.subheadline)
					Text(String(book.writingYear))
						.font(.headline)
				}
			}
			HStack {
				VStack(alignment: .leading) {
					Text("Encuadernación:")
						.font(.subheadline)
					Text(book.coverType.rawValue)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .trailing) {
					Text("ISBN:")
						.font(.subheadline)
					Text("\(book.isbn1)-\(book.isbn2)-\(book.isbn3)-\(book.isbn4)-\(book.isbn5)")
						.font(.headline)
				}
			}
		}
	}
	
	var physicalCharsSection: some View {
		Section {
			HStack {
				VStack {
					Text("Páginas:")
						.font(.subheadline)
					Text(String(book.pages))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Precio:")
						.font(.subheadline)
					Text(book.price, format: .currency(code: "eur"))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Peso (g):")
						.font(.subheadline)
					Text(String(book.weight))
						.font(.headline)
				}
			}
			HStack {
				VStack {
					Text("Alto (cm):")
						.font(.subheadline)
					Text(book.height, format: .number.precision(.fractionLength(1)))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Ancho (cm):")
						.font(.subheadline)
					Text(book.width, format: .number.precision(.fractionLength(1)))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Grosor (cm):")
						.font(.subheadline)
					Text(book.thickness, format: .number.precision(.fractionLength(1)))
						.font(.headline)
				}
			}
		}
	}
}

// View modifier
extension BookDetail {
    struct BookDetailModifier: ViewModifier {
        @Environment(GlobalViewModel.self) var model
        let book: Books
        @Binding var showingDelete: Bool
        @Binding var showingEditPage: Bool
        @Binding var showingInfoAlert: Bool
        @Binding var showingRDDetail: Bool
        @Binding var showingRSDetail: Bool
        let titleInfoAlert: String
        let messageInfoAlert: String
        
        func body(content: Content) -> some View {
			@Bindable var bindingModel = model
			
            content
				.navigationTitle("Detalle (\(book.id) de \(model.userLogic.activeBooks.count))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if book.isActive {
                        HStack {
                            Button {
                                showingDelete = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .disabled(book.status == .reading || book.status == .waiting)
                            Button {
                                showingEditPage = true
                            } label: {
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingEditPage) {
					if let index = model.userLogic.user.books.firstIndex(of: book) {
						BookEditing(book: $bindingModel.userLogic.user.books[index], newBookTitle: book.bookTitle, newStatus: book.status, newOwner: book.owner, newPlace: book.place, newSynopsis: book.synopsis ?? "Sinopsis no disponible.")
                    }
                }
                .alert(titleInfoAlert, isPresented: $showingInfoAlert) {
                    if book.status == .registered {
                        Button("Cancelar", role: .cancel) { }
                        Button("Ver") {
                            showingRDDetail = true
                        }
                    } else if book.status == .reading {
                        Button("Cancelar", role: .cancel) { }
                        Button("Ver") {
                            showingRSDetail = true
                        }
                    } else {
                        Button("Aceptar", role: .cancel) { }
                    }
                } message: {
                    Text(messageInfoAlert)
                }
                .sheet(isPresented: $showingRDDetail) {
					let rdata = model.userLogic.user.readingDatas.first(where: { $0.bookTitle == book.bookTitle })!
                    NavigationView {
                        RDDetail(rdata: rdata)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancelar") {
                                        showingRDDetail = false
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $showingRSDetail) {
					if let rsdata = model.userLogic.user.nowReading.first(where: { $0.bookTitle == book.bookTitle }) {
                        NavigationView {
                            ActualReadingDetail(book: rsdata)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancelar") {
                                            showingRSDetail = false
                                        }
                                    }
                                }
                        }
                    }
                }
                .alert("¿Deseas eliminar este registro?", isPresented: $showingDelete) {
                    Button("Cancelar", role: .cancel) { }
                    Button(soldText, role: .destructive) {
						let index = model.userLogic.user.books.firstIndex(of: book)!
						model.userLogic.user.books[index].place = soldText
						model.userLogic.user.books[index].isActive = false
                    }
                    Button(donatedText, role: .destructive) {
						let index = model.userLogic.user.books.firstIndex(of: book)!
						model.userLogic.user.books[index].place = donatedText
						model.userLogic.user.books[index].isActive = false
                    }
                } message: {
                    Text("Indica si el libro ha sido vendido o donado.")
                }
        }
    }
}
