//
//  DetailView.swift
//  MyLibraryForWatch Watch App
//
//  Created by Javier Rodríguez Gómez on 2/2/23.
//

import SwiftUI

struct DetailView: View {
    @State var book: NowReading
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Image(uiImage: getCoverImage(from: imageCoverName(from: book.bookTitle)))
                        .resizable()
                        .frame(width: 80, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.white, lineWidth: 2)
                        }
                    Spacer()
                    VStack {
                        Text("\(book.progress)%").font(.title2)
                        Text("\(book.nextPage) / \(book.lastPage)").font(.caption2)
                    }
                }
                Divider()
                HStack {
                    Text("Leído:")
                    Spacer()
                    Text(book.readingTime).foregroundColor(.green)
                }
                HStack {
                    Text("Te queda:")
                    Spacer()
                    Text(minPerDayDoubleToString(book.remainingTime)).foregroundColor(.red)
                }
                NavigationLink(destination: TimerView(book: $book)) {
                    Text("Leer")
                }
                .background(Color.blue)
                .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(book: NowReading.example[0])
    }
}
