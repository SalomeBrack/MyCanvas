//
//  GalleryView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI
import CoreData

struct GalleryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Drawing.timestamp, ascending: true)], animation: .default)
    private var drawings: FetchedResults<Drawing>
    
    @State private var drawingName: String = "Untitled"
    @State private var showAddDrawing: Bool = false
    
    var body: some View {
        List {
            ForEach(drawings) { drawing in
                NavigationLink(destination: CanvasView(drawingId: drawing.id!), label: {
                    Text("\(drawing.name!) - \(drawing.timestamp!, formatter: dateFormatter)")
                })
            }
            .onDelete(perform: deleteDrawings)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddDrawing = true },
                       label: { Label("Add Drawing", systemImage: "plus") })
            }
        }
        .sheet(isPresented: $showAddDrawing, content: {
            HStack() {
                Text("Name: ")
                TextField("Drawing Name", text: $drawingName, onCommit: { addDrawing() })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
            
            Button(action: {
                showAddDrawing = false
                addDrawing()
            }, label: { Text("Create") })
        })
    }
    
    private func addDrawing() {
        let newDrawing = Drawing(context: viewContext)
        newDrawing.id = UUID()
        newDrawing.name = drawingName
        newDrawing.timestamp = Date()
        newDrawing.data = Data()
        
        do { try viewContext.save() } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func editDrawing(offsets: IndexSet) {
        //
        
        do { try viewContext.save() } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteDrawings(offsets: IndexSet) {
        offsets.map { drawings[$0] }.forEach(viewContext.delete)
        
        do { try viewContext.save() } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
