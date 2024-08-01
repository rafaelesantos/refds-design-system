import SwiftUI
import RefdsShared

public struct RefdsStoriesViewData {
    public var name: String
    public var color: Color
    public var icon: RefdsIconSymbol
    
    public init(
        name: String,
        color: Color,
        icon: RefdsIconSymbol
    ) {
        self.name = name
        self.color = color
        self.icon = icon
    }
}

public struct RefdsStories: View {
    @Binding private var selection: String?
    private let stories: [RefdsStoriesViewData]
    private let size: CGFloat
    
    public init(
        selection: Binding<String?>,
        stories: [RefdsStoriesViewData],
        size: CGFloat = 40
    ) {
        self._selection = selection
        self.stories = stories
        self.size = size
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .padding(.extraSmall)) {
                    ForEach(stories.indices, id: \.self) { index in
                        let story = stories[index]
                        storyItem(for: story, proxy)
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .padding(.horizontal, -30)
        .onAppear {
            guard selection == nil else { return }
            withAnimation {
                selection = stories.first?.name
            }
        }
    }
    
    private func storyItem(
        for story: RefdsStoriesViewData,
        _ proxy: ScrollViewProxy
    ) -> some View {
        RefdsButton {
            withAnimation {
                selection = story.name
                proxy.scrollTo(story.name, anchor: .center)
            }
        } label: {
            VStack {
                RefdsIcon(
                    story.icon,
                    color: story.color,
                    size: size * 0.375,
                    weight: selection == story.name ? .bold : .regular
                )
                .frame(width: size, height: size)
                .background(story.color.opacity(0.2))
                .clipShape(.circle)
                .padding(size * 0.075)
                .if(selection == story.name) { view in
                    view.overlay {
                        Circle()
                            .stroke(story.color, lineWidth: size * 0.05)
                    }
                }
                .padding(.vertical, size * 0.075)
                
                RefdsText(
                    story.name,
                    style: .caption2,
                    color: selection == story.name ? .primary : .secondary,
                    lineLimit: 1
                )
            }
            .frame(width: size * 1.5)
        }
        .id(story.name)
        .buttonStyle(.plain)
    }
}

#Preview {
    struct ContainerView: View {
        @State private var selection: String?
        private let stories = (1 ... 20).map { _ in
            RefdsStoriesViewData(
                name: .someWord(),
                color: .random,
                icon: .random
            )
        }
        var body: some View {
            List {
                RefdsStories(
                    selection: $selection,
                    stories: stories
                )
                
                RefdsSection {} footer: {
                    RefdsStories(
                        selection: $selection,
                        stories: stories
                    )
                    .padding(-15)
                }
            }
        }
    }
    return ContainerView()
}
