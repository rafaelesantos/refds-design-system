import SwiftUI
import RefdsCore

public struct RefdsWeekdaysCalendar: View {
    @State private var selection: Date
    @State private var dates: [Date] = []
    @State private var selectionIndex: Int = 0
    private let currentDate: Date
    private let color: RefdsColor
    private let onDate: ((Date) -> Void)?
    
    public init(
        selection: Date = .current,
        color: RefdsColor = .accentColor,
        onDate: ((Date) -> Void)? = nil
    ) {
        self._selection = State(initialValue: selection)
        self.color = color
        self.onDate = onDate
        self.currentDate = selection
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 35) {
                weekDays(proxy)
            }
        }
        .padding(.horizontal, -16)
    }
    
    private func weekDays(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(dates.indices, id: \.self) { index in
                    weekDay(proxy, date: dates[index], index: index)
                }
            }
            .padding(.horizontal)
            .onAppear { updateDays(proxy, date: currentDate, needReloadDays: true) }
        }
    }
    
    private func weekDay(_ proxy: ScrollViewProxy, date: Date, index: Int) -> some View {
        RefdsButton {
            updateDays(proxy, date: date, needReloadDays: false)
            onDate?(date)
        } label: {
            VStack {
                let textColor = selectedDateTextColor(with: date)
                RefdsText(date.asString(withDateFormat: .custom("EEEE")).uppercased(), style: .custom(10), color: textColor, weight: .bold)
                RefdsText(date.asString(withDateFormat: .custom("dd")), style: .custom(12), color: textColor, weight: .light)
            }
            .frame(width: 65)
            .padding(8)
            .background(selectedDateBackgroundColor(with: date))
            .cornerRadius(6)
            .opacity(abs(selectionIndex - index) < 2 ? 1 : 0.5)
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
        if let correctDate = date.asString(withDateFormat: .dayMonthYear).asDate(withFormat: .dayMonthYear) {
            selection = correctDate
            
            if needReloadDays {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: currentDate)
                let dayOfWeek = calendar.component(.weekday, from: today)
                dates = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
                    .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            }
            
            selectionIndex = dates.firstIndex(where: { isSelectedDate(with: $0) }) ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation { proxy.scrollTo(selection, anchor: .center) }
            }
        }
    }
}

struct RefdsWeekdaysCalendar_Previews: PreviewProvider {
    static var previews: some View {
        RefdsWeekdaysCalendar()
            .padding(.horizontal)
    }
}
