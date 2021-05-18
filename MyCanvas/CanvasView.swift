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
    @State var activeTool: ActiveTool = .ink
    @State var sheetIsPresented: Bool = false
    @State var alertIsPresented: Bool = false
    
    @State var canvasView = PKCanvasView()
    //@State var toolPicker = PKToolPicker()

    /// Stift Eigenschaften
    @State var inkingTool: PKInkingTool.InkType = .pen
    
    @State var rulerActive: Bool = false
    
    @State var toolWidth: CGFloat = 25
    @State var toolOpacity: Double = 1
    @State var hsb: [Double] = [0, 0, 0]

    let pencilInteraction = UIPencilInteraction()
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                /// Stift / Radierer auswählen
                Button(action: { activeTool = .ink }, label: { Text("Brush").fontWeight(activeTool == .ink  ? .bold : .none) })
                
                Button(action: { activeTool = .eraser }, label: { Text("Eraser").fontWeight(activeTool == .eraser ? .bold : .none) })
                
                Button(action: { activeTool = .lasso }, label: { Text("Lasso").fontWeight(activeTool == .lasso ? .bold : .none) })
                
                Button(action: { rulerActive.toggle() }, label: { Text("Ruler").fontWeight(rulerActive ? .bold : .none) })
            
                Spacer()
                
                /// Tool Einstellungen
                Button(action: { activeSheet = .properties }, label: { Text("Properties").bold() })
                
                /// Color Picker
                Button(action: { activeSheet = .color }, label: {
                    Text("Color").bold()
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.4), lineWidth: 2)
                        .frame(width: 35, height: 35)
                        .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2])))
                })
                //ColorPicker(selection: $color, supportsOpacity: false, label: { Text("Color") })
                
            }.padding()
            
            CanvasWrapper(drawingId: drawingId, canvasView: $canvasView, activeTool: $activeTool, inkType: $inkingTool, rulerActive: $rulerActive, toolWidth: $toolWidth, toolOpacity: $toolOpacity, hsb: $hsb).ignoresSafeArea()
            
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
                        
                        Toggle(isOn: $preferences.vectorEraser) { Text("Vector Eraser") }
                        
                    }.padding()
                    
                /// Stift Eigenschaften
                case .properties:
                    PropertiesView(inkingTool: $inkingTool, toolWidth: $toolWidth, toolOpacity: $toolOpacity)
                    
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
            //.onTapGesture(count: 2, perform: { eraserActive.toggle() })
        }
    }
}

enum ActiveSheet: Identifiable {
    case settings, properties, color
    var id: Int { hashValue }
}

enum ActiveTool: Identifiable {
    case ink, eraser, lasso
    var id: Int { hashValue }
}

/// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
/// https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
