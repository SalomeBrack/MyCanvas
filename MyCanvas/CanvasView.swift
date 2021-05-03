//
//  CanvasView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//


import SwiftUI
import PencilKit

struct CanvasView: View {
    @Environment(\.colorScheme) var colorScheme
    var drawingId: UUID
    
    /// Dark Mode
    @ObservedObject var preferences = Preferences()
    
    /// Stift auswählen
    @State var inkColor: Color = .black
    @State var inkType: PKInkingTool.InkType = .pen
    @State var eraser: PKEraserTool = PKEraserTool(.bitmap)
    @State var eraserOn: Bool = false
    
    @State var sheetIsPresented: Bool = false
    
    var body: some View {
        CanvasWrapper(drawingId: drawingId, inkColor: $inkColor, inkType: $inkType, eraser: $eraser, eraserOn: $eraserOn)
            .ignoresSafeArea()
            .navigationBarItems(trailing: HStack(spacing: 25) {
                /// Color Picker
                ColorPicker(selection: $inkColor, supportsOpacity: true, label: { Text("Color") })
                
                /// Stift / Radierer auswählen
                Menu {
                    Button(action: {
                        inkType = .pen
                        eraserOn = false
                    }, label: {
                        Label("Pen", systemImage: inkType == .pen && !eraserOn ? "pencil" : "")
                    })
                    Button(action: {
                        inkType = .marker
                        eraserOn = false
                    }, label: {
                        Label("Marker", systemImage: inkType == .marker && !eraserOn ? "pencil" : "")
                    })
                    Button(action: {
                        inkType = .pencil
                        eraserOn = false
                    }, label: {
                        Label("Pencil", systemImage: inkType == .pencil && !eraserOn ? "pencil" : "")
                    })
                    Button(action: {
                        eraser = PKEraserTool(.bitmap)
                        eraserOn = true
                    }, label: {
                        Label("Bitmap Eraser", systemImage: eraser == PKEraserTool(.bitmap) && eraserOn ? "pencil.slash" : "")
                    })
                    Button(action: {
                        eraser = PKEraserTool(.vector)
                        eraserOn = true
                    }, label: {
                        Label("Vector Eraser", systemImage: eraser == PKEraserTool(.vector) && eraserOn ? "pencil.slash" : "")
                    })
                } label: { Label("Tool", systemImage: "pencil.tip") }
                
                /// Settings
                Button(action: { sheetIsPresented.toggle() }, label: { Label("Settings", systemImage: "circle") })
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
    }
}

/// https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
/// https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/
