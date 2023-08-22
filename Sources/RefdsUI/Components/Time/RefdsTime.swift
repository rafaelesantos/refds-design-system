import SwiftUI

public struct RefdsTime: View {
    private let format: Format
    private let font: RefdsText.Style
    private let color: RefdsColor
    @State private var minute: Int
    @State private var second: Int
    @State private var hour: Int
    
    @Binding private var time: Int
    
    public init(time: Binding<Int>, format: Format = .hourMinute, font: RefdsText.Style = .body, color: RefdsColor = .accentColor) {
        self._time = time
        self.format = format
        self.font = font
        self.color = color
        
        let hour = time.wrappedValue >= 3600 ? (time.wrappedValue / 3600) : 0
        let minute = (time.wrappedValue - (hour * 3600)) >= 60 ? (time.wrappedValue - (hour * 3600)) / 60 : 0
        let second = (time.wrappedValue - (hour * 3600) - (minute * 60)) >= 0 ? (time.wrappedValue - (hour * 3600) - (minute * 60)) : 0
        
        self._hour = State(initialValue: hour)
        self._minute = State(initialValue: minute)
        self._second = State(initialValue: second)
    }
    
    public var body: some View {
        menuByFormat
    }
    
    @ViewBuilder
    private var menuByFormat: some View {
        switch format {
        case .hour: menu { hour } delegate: { hour = $0 }
        case .minute: menu { minute } delegate: { minute = $0 }
        case .secont: menu { second } delegate: { second = $0 }
        case .hourMinuteSecond: menuHourMinuteSecond
        case .hourMinute: menuHourMinute
        case .minuteSecond: menuMinuteSecond
        }
    }
    
    private func menu(dataSource: @escaping () -> Int, delegate: @escaping (Int) -> Void) -> some View {
        Menu {
            ForEach(Array(0...59), id: \.self) { value in
                RefdsButton {
                    delegate(value)
                    updateTime()
                } label: {
                    RefdsText(String(format: "%02.d", value))
                }
            }
        } label: {
            RefdsText("\(dataSource())", style: font, weight: .medium)
        }
        .padding(6)
        .frame(width: 40)
        .overlay {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(color.opacity(0.5), lineWidth: 2)
        }
    }
    
    private func updateTime() {
        time = (hour * 3600) + (minute * 60) + second
    }
    
    private var menuHourMinuteSecond: some View {
        HStack {
            menu { hour } delegate: { hour = $0 }
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu { minute } delegate: { minute = $0 }
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu { second } delegate: { second = $0 }
        }
    }
    
    private var menuMinuteSecond: some View {
        HStack {
            menu { minute } delegate: { minute = $0 }
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu { second } delegate: { second = $0 }
        }
    }
    
    private var menuHourMinute: some View {
        HStack {
            menu { hour } delegate: { hour = $0 }
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu { minute } delegate: { minute = $0 }
        }
    }
}

public extension RefdsTime {
    enum Format {
        case hour
        case minute
        case secont
        case hourMinuteSecond
        case hourMinute
        case minuteSecond
    }
}

struct RefdsTimeView: View {
    @State private var time: Int = 4200
    var body: some View {
        RefdsTime(time: $time, format: .hourMinuteSecond, font: .body, color: .accentColor)
    }
}

struct RefdsTime_Previews: PreviewProvider {
    static var previews: some View {
        RefdsTimeView()
    }
}
