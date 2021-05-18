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
    @ObservedObject var preferences = Preferences()
    
    @State var activeSheet: ActiveSheet?
    @State var sheetIsPresented: Bool = false
    @State var alertIsPresented: Bool = false
    
    @State var canvasView = PKCanvasView()
    //@State var toolPicker = PKToolPicker()

    /// Stift Eigenschaften
    @State var inkingTool: PKInkingTool.InkType = .pen
    @State var eraserTool: PKEraserTool = PKEraserTool(.vector)
    @State var lassoTool: PKLassoTool = PKLassoTool()
    
    @State var eraserOn: Bool = false
    @State var lassoOn: Bool = false
    
    @State var toolWidth: CGFloat = 25
    @State var toolOpacity: Double = 1
    @State var hsb: [Double] = [0, 0, 0]

    let pencilInteraction = UIPencilInteraction()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                /// Stift / Radierer auswählen
                Button(action: { eraserOn = false }, label: { Text("Tool").accentColor(eraserOn ? .primary : .accentColor) })
                .contextMenu {
                    Button(action: {
                        inkingTool = .pen
                        eraserOn = false
                    }, label: { Label("Pen", systemImage: inkingTool == .pen ? "pencil" : "") })
                    
                    Button(action: {
                        inkingTool = .marker
                        eraserOn = false
                    }, label: { Label("Marker", systemImage: inkingTool == .marker ? "pencil" : "") })
                    
                    Button(action: {
                        inkingTool = .pencil
                        eraserOn = false
                    }, label: { Label("Pencil", systemImage: inkingTool == .pencil ? "pencil" : "") })
                }
                
                Button(action: { eraserOn = true }, label: { Text("Eraser").accentColor(eraserOn ? .accentColor : .primary) })
                .contextMenu {
                    Button(action: {
                        eraserTool = PKEraserTool(.bitmap)
                        eraserOn = true
                    }, label: { Label("Bitmap Eraser", systemImage: eraserTool == PKEraserTool(.bitmap) ? "pencil.slash" : "") })
                    
                    Button(action: {
                        eraserTool = PKEraserTool(.vector)
                        eraserOn = true
                    }, label: { Label("Vector Eraser", systemImage: eraserTool == PKEraserTool(.vector) ? "pencil.slash" : "") })
                }
            
                Spacer()
            
                /// Color Picker
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.primary, lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .background(RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2])))
                    .onTapGesture { activeSheet = .color }
                //ColorPicker(selection: $color, supportsOpacity: false, label: { Text("Color") })
            }
            .padding()
            
            HStack {
                Text("Size:").frame(minWidth: 90, alignment: .trailing)
                Text("\(toolWidth, specifier: "%.0f")").frame(minWidth: 40, alignment: .leading)
                Slider(value: $toolWidth, in: 0.1...25).padding()
            }
            HStack {
                Text("Opacity:").frame(minWidth: 90, alignment: .trailing)
                Text("\(toolOpacity * 100, specifier: "%.0f")").frame(minWidth: 40, alignment: .leading)
                Slider(value: $toolOpacity, in: 0.01...1).padding()
            }
            
            CanvasWrapper(drawingId: drawingId, canvasView: $canvasView, inkType: $inkingTool, eraserTool: $eraserTool, lassoTool: $lassoTool, eraserOn: $eraserOn, lassoOn: $lassoOn, toolWidth: $toolWidth, toolOpacity: $toolOpacity, hsb: $hsb).ignoresSafeArea()
            
            .navigationBarItems(
                leading: HStack(spacing: 25) { Text("")
                    /// Rückgängig, Wiederholen und Löschen
                    Button(action: { undoManager?.undo() }, label: { Text("Undo") }).disabled(undoManager?.canUndo == false)
                    Button(action: { undoManager?.redo() }, label: { Text("Redo") }).disabled(undoManager?.canRedo == false)
                    Button(action: { alertIsPresented = true }, label: { Text("Clear") })
                    
                },
                
                trailing: HStack(spacing: 25) {
                    /// Settings
                    Button(action: { activeSheet = .settings }, label: { Text("Settings") })
                }
            )
            
            .sheet(item: $activeSheet) { item in
                switch item {
                
                /// Einstellungen
                case .settings:
                    VStack(spacing: 25) {
                        Toggle(isOn: $preferences.darkMode) { Text("Dark Mode") }
                        
                        if UIDevice.current.userInterfaceIdiom == .pad
                        { Toggle(isOn: $preferences.pencilOnly) { Text("Pencil Only Mode") } }
                        
                    }.padding()
                    
                /// Farbe wählen
                case .color:
                    ColorView(hsb: $hsb)
                }
            }
                
            /// Alles löschen, Alert Fenster
            .alert(isPresented: $alertIsPresented) { Alert(
                title: Text("Delete Everything?"),
                message: Text("This action is undoable"),
                primaryButton: .destructive(Text("Clear")) {
                    canvasView.drawing = PKDrawing()
                    undoManager?.removeAllActions()
                }, secondaryButton: .cancel()
            )}
            
            /// Bei Doppeltippen auf Canvas
            .onTapGesture(count: 2, perform: { eraserOn.toggle() })
        }
    }
}

enum ActiveSheet: Identifiable {
    case settings, color
    var id: Int { hashValue }
}

/// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
/// https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
