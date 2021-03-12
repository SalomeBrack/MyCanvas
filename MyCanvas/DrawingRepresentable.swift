//
//  CanvasRepresentable.swift
//  MyCanvas
//
//  Created by Student on 12.03.21.
//

import SwiftUI

struct DrawingViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewController = DrawingViewController
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        let viewController = DrawingViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        
    }
}

struct DrawingViewControllerRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        DrawingViewControllerRepresentable()
    }
}
