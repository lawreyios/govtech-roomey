//
//  HorizontalLine.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/23/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

private struct HorizontalLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fill = CGRect(x: .zero, y: .zero, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        return path
    }
}

struct HorizontalLine: View {
    var body: some View {
        HorizontalLineShape()
            .fill(Color.gray)
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .textFieldLineHeight, maxHeight: .textFieldLineHeight)
            .opacity(0.5)
    }
}
