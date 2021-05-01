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
        CanvasWrapper(drawingId: drawingId)
            .ignoresSafeArea()
    }
}
