//
//  ZoomDragGesture.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

struct ZoomDragGesture: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var offset: CGSize
    @Binding var lastOffset: CGSize
    
    func body(content: Content) -> some View {
        content.gesture(
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / lastScale
                        scale *= delta
                        lastScale = value
                        
                        if scale <= 1 {
                            scale = 1
                            offset = .zero
                        }
                    }
                    .onEnded { _ in
                        lastScale = scale
                    },
                DragGesture()
                    .onChanged { value in
                        offset = CGSize(width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height)
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
        )
    }
}
