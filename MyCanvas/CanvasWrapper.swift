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
    @Binding var inkingTool: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var width: CGFloat
    @Binding var opacity: Double
    @Binding var eraser: PKEraserTool
    @Binding var erasing: Bool
    var ink: PKInkingTool { PKInkingTool(inkingTool, color: UIColor(color.opacity(opacity)), width: width) }
    
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
        canvasView.tool = erasing ? eraser : ink
        
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
        canvasView.tool = erasing ? eraser : ink
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
