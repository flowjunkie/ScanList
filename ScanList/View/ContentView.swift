//
//  ContentView.swift
//  ScanList
//
//  Created by Melody Prince on 7/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let scannerView = ScannerView()
        VStack { scannerView }
          .background(.black)
          .foregroundColor(.white)
          .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
