//
//  UserConfigView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/9/23.
//

import LocalAuthentication
import SwiftUI

struct UserConfigView: View {
	@EnvironmentObject var model: UserViewModel
	
	@Binding var isUnlocked: Bool
	@State var showingEditUser = false
	
	@State var showingDeleteButtons = false
	@State var showingDeletingDatas = false
	@State var showingDeletingUser = false
	@State var showingPasswordField = false
	
	@State var password = ""
	@State var deleteOperation = 0
	@State var showingSuccessfulDeleting = false
	@State var showingWrongPassword = false
	
    var body: some View {
		NavigationStack {
			List {
				appearanceButtons
				
				gridButtons
				
				faceIDButtons
				
				deleteButtons
			}
			.modifier(UserConfigViewModifier(showingEditUser: $showingEditUser, showingDeletingDatas: $showingDeletingDatas, showingDeletingUser: $showingDeletingUser, showingPasswordField: $showingPasswordField, password: $password, showingSuccessfulDeleting: $showingSuccessfulDeleting, showingWrongPassword: $showingWrongPassword, authenticateToDelete: authenticateToDelete(_:)))
		}
    }
}

struct UserConfigView_Previews: PreviewProvider {
    static var previews: some View {
		UserConfigView(isUnlocked: .constant(true))
			.environmentObject(UserViewModel())
    }
}
