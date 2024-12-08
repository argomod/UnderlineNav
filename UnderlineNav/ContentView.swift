import SwiftUI

struct ContentView: View {
    @State var currentTab: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Sample content above the underline nav
            SampleView(text: "Sample view")
            // Underline nav bar
            UnderlineNavBar(currentTab: self.$currentTab)
            // Content that changes based on the underline nav
            TabView(selection: self.$currentTab) {
                SampleView(text: "Tab 1").tag(0)
                SampleView(text: "Tab 2").tag(1)
                SampleView(text: "Tab 3").tag(2)
                SampleView(text: "Tab 4").tag(3)
                SampleView(text: "Tab 5").tag(4)
                SampleView(text: "Tab 6").tag(5)
                SampleView(text: "Tab 7").tag(6)
                SampleView(text: "Tab 8").tag(7)
                SampleView(text: "Tab 9").tag(8)
                SampleView(text: "Tab 10").tag(9)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView()
}
