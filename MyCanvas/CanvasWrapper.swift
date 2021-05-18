//
//  CanvasViewRepresentable.swift
//  MyCanvas
//
//  Created by Student on 02.04.21.
//

import SwiftUI
import PencilKit

struct CanvasWrapper: UIViewRepresentable {
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default) private var drawings: FetchedResults<Drawing>
    var drawingId: UUID
    @ObservedObject var preferences = Preferences()
    
    @Binding var canvasView: PKCanvasView
    //@Binding var toolPicker: PKToolPicker
    
    /// Stift auswählen
    @Binding var inkType: PKInkingTool.InkType
    @Binding var eraserTool: PKEraserTool
    @Binding var lassoTool: PKLassoTool
    
    @Binding var eraserOn: Bool
    @Binding var lassoOn: Bool
    
    @Binding var toolWidth: CGFloat
    @Binding var toolOpacity: Double
    @Binding var hsb: [Double]
    
    var inkColor: Color { Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2], opacity: toolOpacity) }
    var inkingTool: PKInkingTool { PKInkingTool(inkType, color: UIColor(inkColor), width: toolWidth) }
    
    func makeUIView(context: Context) -> PKCanvasView {
        /// Bild laden
        if let drawing = drawings.first(where: {$0.id == drawingId}) {
            if let pkDrawing = try? PKDrawing(data: drawing.data ?? Data()) {
                canvasView.drawing = pkDrawing
            }
        }
        
        /// Bild speichern
        canvasView.delegate = context.coordinator
        
        /// Nur Input vom Apple Pencil
        if UIDevice.current.userInterfaceIdiom != .pad { canvasView.drawingPolicy = .anyInput }
        else { canvasView.drawingPolicy = preferences.pencilOnly ? .pencilOnly : .anyInput }
        
        /// Tool Picker
        /*toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()*/
        
        /// Interface Style
        canvasView.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        //toolPicker.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        
        /// Stift auswählen
        canvasView.tool = eraserOn ? eraserTool : inkingTool
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        /// Nur Input vom Apple Pencil
        if UIDevice.current.userInterfaceIdiom != .pad { canvasView.drawingPolicy = .anyInput }
        else { canvasView.drawingPolicy = preferences.pencilOnly ? .pencilOnly : .anyInput }
        
        /// Interface Style
        canvasView.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        //toolPicker.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        
        /// Stift auswählen
        canvasView.tool = eraserOn ? eraserTool : inkingTool
    }
    
    /// Änderungen erkennen
    func makeCoordinator() -> Coordinator {
        Coordinator(saveDrawing: saveDrawing, canvasView: $canvasView)
    }
    
    /// Bild speichern
    func saveDrawing(drawingData: Data) {
        if let drawing = drawings.first(where: {$0.id == drawingId}) {
            drawing.data = drawingData
            PersistenceController.shared.save()
        }
    }
}

/// Bild speichern
class Coordinator: NSObject, PKCanvasViewDelegate {
    let saveDrawing: (Data) -> Void
    let canvasView: Binding<PKCanvasView>
    
    init(saveDrawing: @escaping (Data) -> Void, canvasView: Binding<PKCanvasView>) {
        self.saveDrawing = saveDrawing
        self.canvasView = canvasView
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        saveDrawing(canvasView.drawing.dataRepresentation())
    }
}


/*
 /// Verhindert, dass man etwas malen kann
 canvasView.drawingGestureRecognizer.isEnabled = false
*/
