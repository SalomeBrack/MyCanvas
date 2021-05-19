//
//  Preferences.swift
//  MyCanvas
//
//  Created by Student on 01.05.21.
//

import SwiftUI
import PencilKit

class Preferences: ObservableObject {
    @Published var darkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode") {
        didSet { UserDefaults.standard.set(self.darkMode, forKey: "darkMode") }
    }
    @Published var pencilOnly: Bool = UserDefaults.standard.bool(forKey: "pencilOnly") {
        didSet { UserDefaults.standard.set(self.pencilOnly, forKey: "pencilOnly") }
    }
    @Published var vectorEraser: Bool = UserDefaults.standard.bool(forKey: "vectorEraser") {
        didSet { UserDefaults.standard.set(self.vectorEraser, forKey: "vectorEraser") }
    }
    @Published var toolSettings = UserDefaults.standard.array(forKey: "toolSettings") as? [Double] {
        didSet { UserDefaults.standard.set([0, 0, 0, 1, 25, 0], forKey: "toolSettings") }
    } //[0 hue, 1 saturation, 2 brightness, 3 opacity, 4 width, 5 inkType, 6 selectedTool]
}
