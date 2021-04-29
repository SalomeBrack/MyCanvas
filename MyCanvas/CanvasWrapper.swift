//
//  CanvasViewRepresentable.swift
//  MyCanvas
//
//  Created by Student on 02.04.21.
//

import SwiftUI
import PencilKit

struct CanvasWrapper: UIViewRepresentable {
    var drawing : Drawing
    let onSaved: (Data) -> Void
    
    @State var canvasView = PKCanvasView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        if let pkDrawing = try? PKDrawing(data: drawing.data ?? Data()) { canvasView.drawing = pkDrawing }
        canvasView.delegate = context.coordinator
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSaved: onSaved, canvasView: $canvasView)
    }
}

class Coordinator: NSObject, PKCanvasViewDelegate {
    let onSaved: (Data) -> Void
    let canvasView: Binding<PKCanvasView>
    
    init(onSaved: @escaping (Data) -> Void, canvasView: Binding<PKCanvasView>) {
        self.onSaved = onSaved
        self.canvasView = canvasView
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        onSaved(canvasView.drawing.dataRepresentation())
    }
}
