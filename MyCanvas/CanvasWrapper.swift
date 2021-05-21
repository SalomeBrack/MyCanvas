//
//  CanvasWrapper.swift
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
    @Binding var activeTool: ActiveTool
    @Binding var inkType: PKInkingTool.InkType
    @Binding var rulerActive: Bool
    
    @Binding var toolWidth: Double
    @Binding var toolOpacity: Double
    @Binding var hsb: [Double]
    
    var lassoTool: PKLassoTool = PKLassoTool()
    var eraserTool: PKEraserTool { preferences.vectorEraser ? PKEraserTool(.vector) : PKEraserTool(.bitmap) }
    
    var inkColor: Color { Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2], opacity: toolOpacity) }
    var inkingTool: PKInkingTool { PKInkingTool(inkType, color: UIColor(inkColor), width: CGFloat(toolWidth)) }
    
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
        switch activeTool {
        case .ink: canvasView.tool = inkingTool
        case .eraser: canvasView.tool = eraserTool
        case .lasso: canvasView.tool = lassoTool
        }
        canvasView.isRulerActive = rulerActive
        
        /// Zoomen
        canvasView.maximumZoomScale = 2
        canvasView.minimumZoomScale = 0.5
        canvasView.zoomScale = 1
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        /// Nur Input vom Apple Pencil
        if UIDevice.current.userInterfaceIdiom != .pad { canvasView.drawingPolicy = .anyInput }
        else { canvasView.drawingPolicy = preferences.pencilOnly ? .pencilOnly : .anyInput }
        
        /// Dark oder Light Mode im Canvas
        canvasView.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        //toolPicker.overrideUserInterfaceStyle = preferences.darkMode ? .dark : .light
        
        /// Stift auswählen
        switch activeTool {
        case .ink: canvasView.tool = inkingTool
        case .eraser: canvasView.tool = eraserTool
        case .lasso: canvasView.tool = lassoTool
        }
        canvasView.isRulerActive = rulerActive
        
        // Canvas vergrößern wenn Content näher an den Rand kommt
        if !canvasView.drawing.bounds.isNull {
            let contentWidth = max(canvasView.bounds.width, (canvasView.drawing.bounds.maxX + 1000) * canvasView.zoomScale)
            let contentHeight = max(canvasView.bounds.height, (canvasView.drawing.bounds.maxY + 1000) * canvasView.zoomScale)
            
            canvasView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
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
        
        /// Tool Einstellungen speichern
        UserDefaults.standard.set([hsb[0], hsb[1], hsb[2], toolOpacity, toolWidth,
                                   inkType == .pencil ? 2 : inkType == .marker ? 1 : 0,
                                   activeTool == .lasso ? 2 : activeTool == .eraser ? 1 : 0],
                                  forKey: "toolSettings")
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
