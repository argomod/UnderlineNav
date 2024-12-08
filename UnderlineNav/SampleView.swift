import SwiftUI

struct SampleView: View {
    let text: String
    
    var body: some View {
        Color.clear
            .overlay {
                Text(text)
            }
            .opacity(0.5)
    }
}

#Preview {
    SampleView(text:"Hello, World!")
}
