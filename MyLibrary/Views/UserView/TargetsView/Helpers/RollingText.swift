//
//  RollingText.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/1/23.
//

import SwiftUI

struct RollingText: View, Animatable {
	let color: Color
	var value: Int
	
	var animatableData: Double {
		get { Double(value) }
		set { value = Int(newValue) }
	}
	
	var body: some View {
		Text(value, format: .number)
			.foregroundColor(color)
	}
}


// Código comentado y sustituido por el struct anterior, que es mucho más sencillo y fácil de entender. Se mantiene a modo de ejemplo como alternativa

//struct RollingText: View {
//    let color: Color
//    @Binding var value: Int
//    @State var animationRange: [Int] = []
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(0..<animationRange.count, id: \.self) { index in
//                Text("7")
//                    .font(.largeTitle)
//                    .opacity(0)
//                    .overlay {
//                        GeometryReader { proxy in
//                            let size = proxy.size
//                            VStack(spacing: 0) {
//                                ForEach(0...9, id: \.self) { number in
//                                    Text("\(number)")
//                                        .font(.largeTitle)
//                                        .foregroundColor(color)
//                                        .frame(width: size.width, height: size.height)
//                                }
//                            }
//                            .offset(y: -CGFloat(animationRange[index]) * size.height)
//                        }
//                        .clipped()
//                    }
//            }
//        }
//        .onAppear {
//            animationRange = Array(repeating: 0, count: "\(value)".count)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
//                updateText()
//            }
//        }
//    }
//
//    func updateText() {
//        let stringValue = "\(value)"
//        for (index, value) in zip(0..<stringValue.count, stringValue) {
//            var fraction = Double(index) * 0.15
//            fraction = fraction > 0.5 ? 0.5 : fraction
//            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
//                animationRange[index] = (String(value) as NSString).integerValue
//            }
//        }
//    }
//}

struct RollingText_Previews: PreviewProvider {
    static var previews: some View {
        RollingText(color: .red, value: 123)
    }
}
