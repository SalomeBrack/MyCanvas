//
//  ColorView.swift
//  MyCanvas
//
//  Created by Student on 18.05.21.
//

import SwiftUI

struct ColorView: View {
    @Binding var hsb: [Double]
    var color: Color { Color.init(hue: hsb[0], saturation: hsb[1], brightness: hsb[2]) }
    
    
      @State var sliderValue: Double = 0.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.primary, lineWidth: 5)
                    .frame(width: 150, height: 150)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(color))
                    .padding()
                Spacer()
            }
            
            Text("Hue").padding()
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(
                        gradient: .init(colors: [
                            Color.init(hue: 0, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 60/360, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 120/360, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 180/360, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 240/360, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 300/360, saturation: hsb[1], brightness: hsb[2]),
                            Color.init(hue: 1, saturation: hsb[1], brightness: hsb[2])
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )).frame(maxHeight: 15).padding()
                ColorSlider(thumbColor: UIColor(color), value: $hsb[0])
            }.padding()
            
            Text("Saturation").padding()
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(
                        gradient: .init(colors: [Color.init(hue: hsb[0], saturation: 0, brightness: hsb[2]), Color.init(hue: hsb[0], saturation: 1, brightness: hsb[2])]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )).frame(maxHeight: 15).padding()
                ColorSlider(thumbColor: UIColor(color), value: $hsb[1])
            }.padding()
            
            Text("Brightness").padding()
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient(
                        gradient: .init(colors: [Color.init(hue: hsb[0], saturation: hsb[1], brightness: 0), Color.init(hue: hsb[0], saturation: hsb[1], brightness: 1)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )).frame(maxHeight: 15).padding()
                ColorSlider(thumbColor: UIColor(color), value: $hsb[2])
            }.padding()
            
        /*HStack {
            Text("Hue:").frame(minWidth: 90, alignment: .trailing)
            Text("\(hsb[0] * 360, specifier: "%.0f")").frame(minWidth: 30, alignment: .leading)
            Slider(value: $hsb[0], in: 0...1).padding()
        }
        HStack {
            Text("Saturation:").frame(minWidth: 90, alignment: .trailing)
            Text("\(hsb[1] * 100, specifier: "%.0f")").frame(minWidth: 30, alignment: .leading)
            Slider(value: $hsb[1], in: 0...1).padding()
        }
        HStack {
            Text("Brightness:").frame(minWidth: 90, alignment: .trailing)
            Text("\(hsb[2] * 100, specifier: "%.0f")").frame(minWidth: 30, alignment: .leading)
            Slider(value: $hsb[2], in: 0...1).padding()
        }*/
            
        }.padding()
    }
}


struct ColorSlider: UIViewRepresentable {
    final class Coordinator: NSObject {
        var value: Binding<Double>
        
        init(value: Binding<Double>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
        }
    }
    
    var thumbColor: UIColor?

    @Binding var value: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.value = Float(value)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.thumbTintColor = thumbColor
        uiView.value = Float(self.value)
    }

    func makeCoordinator() -> ColorSlider.Coordinator {
        Coordinator(value: $value)
    }
}
