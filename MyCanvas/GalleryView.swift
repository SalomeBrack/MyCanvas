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
    
    var body: some View {
        List {
            //NavigationLink(destination: CanvasView(drawingName: "Drawing 1"), label: { Text("Drawing")})
            ForEach(drawings) { drawing in
                Text("\(drawing.name ?? "Untitled") - \(drawing.timestamp!, formatter: dateFormatter)")
            }
            .onDelete(perform: deleteDrawings)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                #if os(iOS)
                EditButton()
                #endif
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addDrawing) {
                    Label("Add Drawing", systemImage: "plus")
                }
            }
        }
    }
    
    private func addDrawing() {
        withAnimation {
            let newDrawing = Drawing(context: viewContext)
            newDrawing.id = UUID()
            newDrawing.timestamp = Date()
            newDrawing.data = Data()

            do {
                try viewContext.save()
            } catch {
                // Replace this
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteDrawings(offsets: IndexSet) {
        withAnimation {
            offsets.map { drawings[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
