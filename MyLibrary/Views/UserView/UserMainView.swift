//
//  UserMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/23.
//

import SwiftUI

struct UserMainView: View {
    @EnvironmentObject var model: GlobalViewModel
    @Binding var isUnlocked: Bool
    
    @State var showingClosingAlert = false
    
    @State var showingSelectorPicker = false
    @State var showingImagePicker = false
    @State var showingCameraPicker = false
    @State var image: Image?
    @State var inputImage: UIImage?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    ZStack(alignment: .bottom) {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: geo.size.height/4, height: geo.size.height/4)
                                .foregroundColor(.secondary)
                            HStack(spacing: 25) {
                                Button("Editar") {
                                    showingSelectorPicker = true
                                }
                                Button("Borrar") {
                                    self.image = nil
                                    self.inputImage = nil
                                    removeUserImage()
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.height/6, height: geo.size.height/6)
                                .foregroundColor(.secondary)
                            Button("Editar") {
                                showingSelectorPicker = true
                            }
                            .offset(y: -10)
                        }
                    }
                    List {
                        Section {
                        	NavigationLink(destination: TargetsMainView()) {
								HStack {
									Image(systemName: "chart.pie.fill")
										.foregroundColor(.green)
									Text("Objetivos de lectura")
								}
							}
							NavigationLink(destination: AllQuotesCommentsView()) {
								HStack {
									Image(systemName: "quote.bubble")
										.foregroundColor(.blue)
									Text("Citas y comentarios de sesiones")
								}
							}
							NavigationLink(destination: AllCommentsView()) {
								HStack {
									Image(systemName: "quote.bubble")
										.foregroundColor(.pink)
									Text("Comentarios por libro")
								}
							}
                        }
						
						Section {
							NavigationLink(destination: UserConfigView(isUnlocked: $isUnlocked)) {
								Label("Ajustes personales", systemImage: "gear")
							}
						}
						
						Section {
                            Button(role: .destructive) {
                                showingClosingAlert = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Cerrar sesión")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
			.modifier(UserMainViewModifier(showingClosingAlert: $showingClosingAlert, isUnlocked: $isUnlocked, showingSelectorPicker: $showingSelectorPicker, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, image: $image, inputImage: $inputImage, loadImage: loadImage))
        }
    }
}

struct UserMainView_Previews: PreviewProvider {
    static var previews: some View {
        UserMainView(isUnlocked: .constant(true))
			.environmentObject(GlobalViewModel.preview)
    }
}
