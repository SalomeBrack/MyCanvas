//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    @Environment(\.undoManager) private var undoManager
    var drawingId: UUID
    
    /// Dark Mode
    @ObservedObject var preferences = Preferences()
    @State var sheetIsPresented: Bool = false
    @State var alertIsPresented: Bool = false
    
    //@State var canvasView = PKCanvasView()
    //@State var toolPicker = PKToolPicker()

    /// Stift Eigenschaften
    @State var color: Color = .black
    @State var inkingTool: PKInkingTool.InkType = .pen
    @State var width: CGFloat = 5
    @State var opacity: Double = 1
    @State var eraser: PKEraserTool = PKEraserTool(.vector)
    @State var erasing: Bool = false

    let pencilInteraction = UIPencilInteraction()
    
    var body: some View {
        VStack {
            HStack {
                Text("Size:").frame(minWidth: 80, alignment: .trailing)
                Text("\(width, specifier: "%.1f") P").frame(minWidth: 50, alignment: .leading)
                Slider(value: $width, in: 0.1...25).padding()
            }
            HStack {
                Text("Opacity:").frame(minWidth: 80, alignment: .trailing)
                Text("\(opacity * 100, specifier: "%.0f") %").frame(minWidth: 50, alignment: .leading)
                Slider(value: $opacity, in: 0.01...1).padding()
            }
        
            CanvasWrapper(drawingId: drawingId, /*canvasView: $canvasView,*/ inkingTool: $inkingTool, color: $color, width: $width, opacity: $opacity, eraser: $eraser, erasing: $erasing)
                
            .ignoresSafeArea()
            .navigationBarItems(trailing: HStack(spacing: 25) {
                /// Rückgängig, Wiederholen und Löschen
                Button(action: { undoManager?.undo() }, label: { Text("Undo") }).disabled(undoManager?.canUndo == false)
                Button(action: { undoManager?.redo() }, label: { Text("Redo") }).disabled(undoManager?.canRedo == false)
                Button(action: { alertIsPresented = true }, label: { Text("Clear") })
                
                /// Color Picker
                ColorPicker(selection: $color, supportsOpacity: false, label: { Text("Color") })
                
                /// Stift / Radierer auswählen
                Menu {
                    Button(action: {
                        //canvasView.tool = PKInkingTool(.pen)
                        inkingTool = .pen
                        erasing = false
                    }, label: { Label("Pen", systemImage: inkingTool == .pen && !erasing ? "pencil" : "") })
                    
                    Button(action: {
                        //canvasView.tool = PKInkingTool(.marker)
                        inkingTool = .marker
                        erasing = false
                    }, label: { Label("Marker", systemImage: inkingTool == .marker && !erasing ? "pencil" : "") })
                    
                    Button(action: {
                        //canvasView.tool = PKInkingTool(.pencil)
                        inkingTool = .pencil
                        erasing = false
                    }, label: { Label("Pencil", systemImage: inkingTool == .pencil && !erasing ? "pencil" : "") })
                    
                    Button(action: {
                        //canvasView.tool = PKEraserTool(.bitmap)
                        eraser = PKEraserTool(.bitmap)
                        erasing = true
                    }, label: { Label("Bitmap Eraser", systemImage: eraser == PKEraserTool(.bitmap) && erasing ? "pencil.slash" : "") })
                    
                    Button(action: {
                        //canvasView.tool = PKEraserTool(.vector)
                        eraser = PKEraserTool(.vector)
                        erasing = true
                    }, label: { Label("Vector Eraser", systemImage: eraser == PKEraserTool(.vector) && erasing ? "pencil.slash" : "") })
                    
                } label: { Label("Tool", systemImage: erasing ? "pencil.slash" : "pencil") }
                
                /// Settings
                Button(action: { sheetIsPresented = true }, label: { Text("Settings") })
            })
            /// Settings
            .sheet(isPresented: $sheetIsPresented) {
                VStack(spacing: 25) {
                    Toggle(isOn: $preferences.darkMode) { Text("Dark Mode") }
                    
                    /// Nur Input vom Apple Pencil
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        Toggle(isOn: $preferences.pencilOnly) { Text("Pencil Only Mode") }
                    }
                }.padding()
            }
            .onTapGesture(count: 2, perform: { erasing.toggle() })
            .alert(isPresented: $alertIsPresented) { Alert(
                title: Text("Delete Everything?"),
                message: Text("This action is undoable"),
                primaryButton: .destructive(Text("Clear")) {
                    //canvasView.drawing = PKDrawing()
                    undoManager?.removeAllActions()
                }, secondaryButton: .cancel()
            )}
        }
    }
}

/// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
/// https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
