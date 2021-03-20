//
//  DrawingViewController.swift
//  MyCanvas
//
//  Created by Student on 12.03.21.
//

import SwiftUI
import PencilKit

class DrawingViewController: UIViewController {
    var canvasView: PKCanvasView = {
        let cv = PKCanvasView()
        //cv.drawingPolicy = .anyInput
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    var toolPicker: PKToolPicker = PKToolPicker()
    
    override func viewDidLoad() {
        view.addSubview(canvasView)
        
        NSLayoutConstraint.activate([
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: view.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        
        canvasView.becomeFirstResponder()
    }
}
