//
//  ToolView.swift
//  MyCanvas
//
//  Created by Student on 18.05.21.
//

import SwiftUI
import PencilKit

struct PropertiesView: View {
    @Binding var inkingTool: PKInkingTool.InkType
    @Binding var toolWidth: CGFloat
    @Binding var toolOpacity: Double
    
    @State var hsb: [Double] = [0, 0, 0]
    var color: Color { Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2]) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 40) {
                Text("Brush: ")
                Spacer()
                Button(action: { inkingTool = .pen }, label: { Text("Pen").fontWeight(inkingTool == .pen ? .bold : .none) })
                Button(action: { inkingTool = .marker }, label: { Text("Marker").fontWeight(inkingTool == .marker ? .bold : .none) })
                Button(action: { inkingTool = .pencil }, label: { Text("Pencil").fontWeight(inkingTool == .pencil ? .bold : .none) })
            }.padding()
            
            Text("")
            
            HStack {
                Text("Size:")
                Spacer()
                Text("\(toolWidth, specifier: "%.0f")")
            }.padding()
            Slider(value: $toolWidth, in: 0.1...25).padding()
            
            HStack {
                Text("Opacity:")
                Spacer()
                Text("\(toolOpacity * 100, specifier: "%.0f")")
            }.padding()
            Slider(value: $toolOpacity, in: 0.01...1).padding()
        }.padding()
    }
}
