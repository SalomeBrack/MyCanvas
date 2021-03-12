//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI

struct CanvasView: View {
    var drawingName: String
    
    var body: some View {
        DrawingViewControllerRepresentable()
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(drawingName: "Drawing 1")
    }
}
