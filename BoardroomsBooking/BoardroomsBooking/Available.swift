//
//  Available.swift
//  BoardroomsBooking
//
//  Created by Sarah on 05/07/1447 AH.
//

//}
import SwiftUI

struct Available: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Image("bg_topo_pattern")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // HEADER
                ZStack {
                    Color(hex: "232455")
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()

                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text("Available Today")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()
                        Spacer().frame(width: 24)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                }
                .frame(height: 110)
                .offset(y: -30)


                // LIST
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<5, id: \.self) { _ in
//                            BookingCard(dateText: "Available")
                            //wed i put this line coment forr testing my api sorry 
                        }
                    }
                    .padding()
                }
            }
        }
    }
}





#Preview {
    Available()
}
