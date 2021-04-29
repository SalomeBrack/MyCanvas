//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    @State var drawingId: UUID
    @State var canvasView = PKCanvasView()
    
    var body: some View {
        CanvasViewRepresentable(drawingId: $drawingId, canvasView: $canvasView)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(drawingId: UUID())
    }
}
