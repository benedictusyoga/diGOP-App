//
//  LogoView.swift
//  diGOP App
//
//  Created by Benedictus Yogatama Favian Satyajati on 24/03/25.
//

import SwiftUI

struct LogoView: View {
    var offset: CGFloat = 0
    var body: some View {
        Image("diGOP Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .offset(y:offset)
    }
}

#Preview {
    LogoView()
}
