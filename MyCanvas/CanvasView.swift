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
    
    var body: some View {
        CanvasViewRepresentable()
    }
}

struct CanvasViewRepresentable: UIViewRepresentable {
    var canvasView: PKCanvasView = PKCanvasView()
    var toolPicker: PKToolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
