//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    var drawingName: String
    
    var body: some View {
        CanvasViewRepresentable()
    }
}

struct CanvasViewRepresentable: UIViewRepresentable {
    var canvasView: PKCanvasView = PKCanvasView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(drawingName: "Drawing 1")
    }
}
