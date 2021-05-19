//
//  GalleryView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI
import PencilKit

struct GalleryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default) private var drawings: FetchedResults<Drawing>
    
    @State var sheetIsPresented: Bool = false
    @State var drawingName: String = ""
    
    var body: some View {
        List {
            ForEach(drawings) { drawing in
                HStack {
                    NavigationLink(destination: CanvasView(drawingId: drawing.id ?? UUID()).ignoresSafeArea(edges: .bottom), label: {
                        Text(drawing.name ?? "Untitled").bold()
                        Text(drawing.timestamp ?? Date(), formatter: dateFormatter).italic()
                    })
                }
            }.onDelete(perform: deleteDrawing)
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    sheetIsPresented = true
                    drawingName = ""
                }, label: { Label("New Drawing", systemImage: "plus") })
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            VStack(spacing: 30) {
                HStack {
                    Text("Name: ")
                    TextField("Name", text: $drawingName).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                    
                HStack(spacing: 60) {
                    Button(action: { sheetIsPresented = false }, label: { Text("Cancel").accentColor(.red) })
                    Button(action: {
                        sheetIsPresented = false
                        addDrawing()
                    }, label: { Text("Create").bold() })
                }
            }.padding().padding()
        }
    }
    
    func addDrawing() {
        let drawing = Drawing(context: viewContext)
        
        drawing.id = UUID()
        drawing.timestamp = Date()
        if (drawingName == "") {
            drawing.name = "Untitled"
        } else {
            drawing.name = drawingName
        }
        
        let pkDrawing : PKDrawing = PKDrawing()
        drawing.data = pkDrawing.dataRepresentation()
        
        PersistenceController.shared.save()
    }
    
    func deleteDrawing(at offsets: IndexSet) {
        for index in offsets {
            let drawing = drawings[index]
            PersistenceController.shared.delete(drawing)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
