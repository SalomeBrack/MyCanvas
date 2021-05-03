//
//  Preferences.swift
//  MyCanvas
//
//  Created by Student on 01.05.21.
//

import SwiftUI

class Preferences: ObservableObject {
    @Published var darkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode") {
        didSet { UserDefaults.standard.set(self.darkMode, forKey: "darkMode") }
    }
    @Published var pencilOnly: Bool = UserDefaults.standard.bool(forKey: "pencilOnly") {
        didSet { UserDefaults.standard.set(self.pencilOnly, forKey: "pencilOnly") }
    }
}
