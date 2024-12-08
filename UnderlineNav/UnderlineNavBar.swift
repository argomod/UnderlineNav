import SwiftUI

// MARK: List of tabs
private enum TabbedItems: Int, CaseIterable{
    case one = 0
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    
    var title: String {
        switch self {
        case .one:
            return "One"
        case .two:
            return "Two"
        case .three:
            return "Three"
        case .four:
            return "Four"
        case .five:
            return "Five"
        case .six:
            return "Six"
        case .seven:
            return "Seven"
        case .eight:
            return "Eight"
        case .nine:
            return "Nine"
        case .ten:
            return "Ten"
        }
    }
}

// MARK: Underline nav item
struct UnderlineNavItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                // Name of tab
                Text(tabBarItemName)
                    .foregroundStyle(currentTab == tab ? Color.clear : .secondary)
                    .overlay {
                        Text(tabBarItemName)
                            .foregroundStyle(currentTab == tab ? .primary : Color.clear)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                Group {
                    if currentTab == tab {
                        // Underline when active
                        Color.primary
                            .frame(height: 2)
                            .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                    } else {
                        // Underline when inactive
                        Color.clear
                            .frame(height: 2)
                    }
                }
                .animation(.easeOut(duration: 0.3), value: self.currentTab)
            }
            
        }
        .buttonStyle(.plain)
    }
}


// MARK: Underline nav bar
struct UnderlineNavBar: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var body: some View {
        ScrollViewReader { value in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        // All underline nav items
                        ForEach(TabbedItems.allCases, id: \.self) { index in
                            UnderlineNavItem(currentTab: self.$currentTab,
                                             namespace: namespace.self,
                                             tabBarItemName: index.title,
                                             tab: index.rawValue)
                            .id(index.rawValue)
                        }
                    }
                    .padding(.horizontal, 24)
                    // Centers current nav item
                    .onAppear {
                        withAnimation {
                            value.scrollTo(currentTab, anchor: .center)
                        }
                    }
                    // Centers current nav item when changed
                    .onChange(of: currentTab) {
                        withAnimation {
                            value.scrollTo(currentTab, anchor: .center)
                        }
                        var highPriorityAnnouncement = AttributedString(TabbedItems.allCases[self.currentTab].title)
                        highPriorityAnnouncement.accessibilitySpeechAnnouncementPriority = .high
                        AccessibilityNotification.Announcement(highPriorityAnnouncement).post()
                    }
                    .scrollTargetLayout()
                    .accessibilityElement()
                    // This label reads aloud to VoiceOver users when they navigate to the underline nav bar
                    // TODO: Change this label to whatever makes most sense for your use case
                    .accessibilityLabel("Your navigation, currently on \(TabbedItems.allCases[self.currentTab].title)")
                    // Swipe up moves forward, swipe down moves backward
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment:
                            if self.currentTab < TabbedItems.allCases.count - 1 {
                                currentTab = self.currentTab + 1
                            }
                        case .decrement:
                            if self.currentTab != 0 {
                                currentTab = self.currentTab - 1
                            }
                        @unknown default:
                            break
                        }
                    }
                    // Reads the name of the current tab aloud to VoiceOver users when they click on the underline nav bar
                    .accessibilityAction {
                        var highPriorityAnnouncement = AttributedString("Currently on \(TabbedItems.allCases[self.currentTab].title)")
                        highPriorityAnnouncement.accessibilitySpeechAnnouncementPriority = .high
                        AccessibilityNotification.Announcement(highPriorityAnnouncement).post()
                    }
                }
                // Bottom underline
                Color.primary
                    .frame(height: 1)
                    .opacity(0.2)
            }
        }
    }
}

// MARK: For preview only
struct UnderlineNavBarPreview: View {
    @State var currentTab: Int = 0
    
    var body: some View {
        UnderlineNavBar(currentTab: self.$currentTab)
    }
}

#Preview {
    UnderlineNavBarPreview()
}
