import SwiftUI

public struct RefdsMonthCalendar: View {
    @Binding private var selection: Date
    @State private var selectionIndex: Int = 0
    @State private var days: [Date] = []
    private let color: RefdsColor
    
    public init(selection: Binding<Date>, color: RefdsColor = .accentColor) {
        self._selection = selection
        self.color = color
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 35) {
                header(proxy)
                weekDays(proxy)
            }
        }
    }
    
    private func header(_ proxy: ScrollViewProxy) -> some View {
        HStack(spacing: 30) {
            RefdsButton { updateMonth(proxy, value: -1) } label: {
                RefdsIcon(
                    symbol: .chevronLeftCircleFill,
                    color: color,
                    size: 20,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
            }
            
            RefdsText(selection.asString(withDateFormat: .custom("MMMM yyyy")))
            
            RefdsButton { updateMonth(proxy, value: 1) } label: {
                RefdsIcon(
                    symbol: .chevronRightCircleFill,
                    color: color,
                    size: 20,
                    weight: .bold,
                    renderingMode: .hierarchical
                )
            }
        }
    }
    
    private func weekDays(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(days.indices, id: \.self) { index in
                    weekDay(proxy, date: days[index], index: index)
                }
            }
            .padding(.horizontal)
            .onAppear { updateDays(proxy, date: selection, needReloadDays: true) }
        }
    }
    
    private func weekDay(_ proxy: ScrollViewProxy, date: Date, index: Int) -> some View {
        RefdsButton { updateDays(proxy, date: date, needReloadDays: false) } label: {
            VStack {
                let textColor = selectedDateTextColor(with: date)
                RefdsText(date.asString(withDateFormat: .custom("EEE")).uppercased(), style: .custom(8), color: textColor, weight: .light)
                RefdsText(date.asString(withDateFormat: .custom("dd")), style: .body, color: textColor, weight: .bold)
            }
            .frame(width: 25)
            .padding(8)
            .background(selectedDateBackgroundColor(with: date))
            .cornerRadius(6)
            .opacity(abs(selectionIndex - index) < 3 ? 1 : 0.5)
        }
        .id(date)
    }
    
    private func isSelectedDate(with date: Date) -> Bool {
        let selectedDate = selection.asString(withDateFormat: .dayMonthYear)
        let date = date.asString(withDateFormat: .dayMonthYear)
        return selectedDate == date
    }
    
    private func selectedDateBackgroundColor(with date: Date) -> RefdsColor {
        isSelectedDate(with: date) ? color : .secondary.opacity(0.1)
    }
    
    private func selectedDateTextColor(with date: Date) -> RefdsColor {
        isSelectedDate(with: date) ? .white : .primary
    }
    
    private func updateDays(_ proxy: ScrollViewProxy, date: Date, needReloadDays: Bool) {
        let calendar = Calendar.current
        if let correctDate = date.asString(withDateFormat: .dayMonthYear).asDate(withFormat: .dayMonthYear),
           let interval = calendar.dateInterval(of: .month, for: correctDate) {
            selection = correctDate
            
            if needReloadDays {
                days = calendar.generateDates(inside: interval, matching: DateComponents(hour: 0, minute: 0, second: 0))
            }
            
            selectionIndex = days.firstIndex(where: { isSelectedDate(with: $0) }) ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { proxy.scrollTo(selection, anchor: .center) }
            }
        }
    }
    
    private func updateMonth(_ proxy: ScrollViewProxy, value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selection) {
            updateDays(proxy, date: newMonth, needReloadDays: true)
        }
    }
}

struct RefdsMonthCalendar_Previews: PreviewProvider {
    static var date: Date = .current
    static var previews: some View {
        NavigationView {
            RefdsMonthCalendar(selection: Binding(
                get: { date },
                set: { date = $0 }
            ))
        }
    }
}
