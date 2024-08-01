import SwiftUI
import RefdsShared

public protocol RefdsStoriesProtocol {
    var name: String { get set }
    var color: Color { get set }
    var icon: RefdsIconSymbol { get set }
}

private struct RefdsStoriesViewDataMock: RefdsStoriesProtocol {
    var name: String = .someWord()
    var color: Color = .random
    var icon: RefdsIconSymbol = .random
    
    init() {}
}

public struct RefdsStories: View {
    @Binding private var selection: RefdsStoriesProtocol?
    private let stories: [RefdsStoriesProtocol]
    private let size: CGFloat
    
    public init(
        selection: Binding<RefdsStoriesProtocol?>,
        stories: [RefdsStoriesProtocol],
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
        .onAppear { selection = stories.first }
    }
    
    private func storyItem(
        for story: RefdsStoriesProtocol,
        _ proxy: ScrollViewProxy
    ) -> some View {
        RefdsButton {
            withAnimation {
                selection = story
                proxy.scrollTo(story.name, anchor: .center)
            }
        } label: {
            VStack {
                RefdsIcon(
                    story.icon,
                    color: story.color,
                    size: size * 0.375,
                    weight: selection?.name == story.name ? .bold : .regular
                )
                .frame(width: size, height: size)
                .background(story.color.opacity(0.2))
                .clipShape(.circle)
                .padding(size * 0.075)
                .if(selection?.name == story.name) { view in
                    view.overlay {
                        Circle()
                            .stroke(story.color, lineWidth: size * 0.05)
                    }
                }
                .padding(.vertical, size * 0.075)
                
                RefdsText(
                    story.name,
                    style: .caption2,
                    color: selection?.name == story.name ? .primary : .secondary,
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
        @State private var selection: RefdsStoriesProtocol?
        private let stories = (1 ... 20).map { _ in RefdsStoriesViewDataMock() }
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
