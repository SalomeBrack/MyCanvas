//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    var drawingId: UUID
    
    @State var selectedColor: Color = .blue
    
    var body: some View {
        CanvasWrapper(drawingId: drawingId, selectedColor: $selectedColor)
            .ignoresSafeArea()
            /// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
            .navigationBarItems(trailing:
                Button(action: {
                    /// Stift auswählen
                }, label: {
                    Image(systemName: "pencil.tip")
                })
            )
    }
}
