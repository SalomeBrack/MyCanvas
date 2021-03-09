//
//  GalleryView.swift
//  MyCanvas
//
//  Created by Student on 09.03.21.
//

import SwiftUI

struct GalleryView: View {
    var body: some View {
        List {
            NavigationLink(
                destination:
                    CanvasView(drawingName: "Drawing 1"),
                label: {
                    Text("Drawing")
                })
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
