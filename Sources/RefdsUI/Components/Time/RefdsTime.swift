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
        case .hour: menu(.hour)
        case .minute: menu(.minute)
        case .secont: menu(.secont)
        case .hourMinuteSecond: menuHourMinuteSecond
        case .hourMinute: menuHourMinute
        case .minuteSecond: menuMinuteSecond
        }
    }
    
    @ViewBuilder
    private func menu(_ format: Format) -> some View {
        Menu {
            ForEach(Array(0...59), id: \.self) { value in
                RefdsButton {
                    switch format {
                    case .hour: hour = value
                    case .minute: minute = value
                    case .secont: second = value
                    default: break
                    }
                    updateTime()
                } label: {
                    RefdsText("\(value)")
                }
            }
        } label: {
            VStack {
                switch format {
                case .hour:
                    RefdsText("hor.".uppercased(), style: .custom(font.value * 0.47), weight: .light)
                    RefdsText("\(hour)", style: font, weight: .bold)
                case .minute:
                    RefdsText("min.".uppercased(), style: .custom(font.value * 0.47), weight: .light)
                    RefdsText("\(minute)", style: font, weight: .bold)
                case .secont:
                    RefdsText("seg.".uppercased(), style: .custom(font.value * 0.47), weight: .light)
                    RefdsText("\(second)", style: font, weight: .bold)
                default: EmptyView()
                }
            }
            .frame(width: 25)
            .padding(8)
            .background(color.opacity(0.1))
            .cornerRadius(6)
        }
        
    }
    
    private func updateTime() {
        time = (hour * 3600) + (minute * 60) + second
    }
    
    private var menuHourMinuteSecond: some View {
        HStack {
            menu(.hour)
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu(.minute)
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu(.secont)
        }
    }
    
    private var menuMinuteSecond: some View {
        HStack {
            menu(.minute)
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu(.secont)
        }
    }
    
    private var menuHourMinute: some View {
        HStack {
            menu(.hour)
            RefdsText(":", style: .title2, color: color, weight: .bold)
            menu(.minute)
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
        RefdsTime(time: $time, format: .minuteSecond, font: .body, color: .accentColor)
    }
}

struct RefdsTime_Previews: PreviewProvider {
    static var previews: some View {
        RefdsTimeView()
    }
}
