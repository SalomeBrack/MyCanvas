//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    @ObservedObject var preferences = Preferences()
    @Environment(\.undoManager) private var undoManager
    var drawingId: UUID
    
    @State var activeSheet: ActiveSheet?
    @State var activeTool: ActiveTool = .ink
    @State var alertIsPresented: Bool = false
    
    @State var canvasView = PKCanvasView()
    //@State var toolPicker = PKToolPicker()

    /// Stift Eigenschaften
    @State var inkingTool: PKInkingTool.InkType = .pen
    @State var rulerActive: Bool = false
    @State var toolWidth: Double = 25
    @State var toolOpacity: Double = 1
    @State var hsb: [Double] = [0, 0, 0]
    var selectedColor: Color { Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2]) }
    
    var body: some View {
        VStack {
            /// Untere Leiste
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
                        .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(selectedColor))
                })
                //ColorPicker(selection: $color, supportsOpacity: false, label: { Text("Color") })
            }.padding()
            
            /// Canvas
            CanvasWrapper(drawingId: drawingId, canvasView: $canvasView, activeTool: $activeTool, inkType: $inkingTool, rulerActive: $rulerActive, toolWidth: $toolWidth, toolOpacity: $toolOpacity, hsb: $hsb)
            
            /// Obere Leiste
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
            /// Sheet für Einstellungen, Stift-Einstellungen, Farbe
            .sheet(item: $activeSheet) { item in
                VStack {
                    switch item {
                    case .settings:
                        SettingsView()
                    case .properties:
                        PropertiesView(inkingTool: $inkingTool, toolWidth: $toolWidth, toolOpacity: $toolOpacity)
                    case .color:
                        ColorView(hsb: $hsb)
                    }
                    
                    Spacer()
                    
                    Button(action: { activeSheet = .none }, label: { Text("Done") }).padding()
                }.padding().padding()
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
        }
        .onAppear {
            /// Tool Settings laden
            hsb = [preferences.toolSettings?[0] ?? 0, preferences.toolSettings?[1] ?? 0, preferences.toolSettings?[2] ?? 0]
            toolOpacity = preferences.toolSettings?[3] ?? 1
            toolWidth = preferences.toolSettings?[4] ?? 25
            inkingTool = preferences.toolSettings?[5] ?? 0 == 2 ? .pencil : preferences.toolSettings?[5] ?? 0 == 1 ? .marker : .pen
            activeTool = preferences.toolSettings?[6] ?? 0 == 2 ? .lasso : preferences.toolSettings?[6] ?? 0 == 1 ? .eraser : .ink
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
