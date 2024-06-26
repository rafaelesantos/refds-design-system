import SwiftUI

public struct RefdsMonthCalendar: View {
    @Binding private var selection: Date
    @State private var selectionIndex: Int = 0
    @State private var days: [Date] = []
    private let color: Color
    
    public init(
        selection: Binding<Date>,
        color: Color = .accentColor
    ) {
        self._selection = selection
        self.color = color
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: .padding(.large)) {
                header(proxy)
                weekDays(proxy)
            }
        }
    }
    
    private func header(_ proxy: ScrollViewProxy) -> some View {
        HStack(spacing: .padding(.extraLarge)) {
            RefdsButton { updateMonth(proxy, value: -1) } label: {
                RefdsIcon(
                    .chevronLeft,
                    color: color,
                    style: .caption,
                    weight: .bold
                )
                .frame(width: .padding(.large), height: .padding(.large))
                .background(color.opacity(0.2))
                .clipShape(.circle)
            }
            
            RefdsText(selection.asString(withDateFormat: .custom("MMMM yyyy")))
            
            RefdsButton { updateMonth(proxy, value: 1) } label: {
                RefdsIcon(
                    .chevronRight,
                    color: color,
                    style: .caption,
                    weight: .bold
                )
                .frame(width: .padding(.large), height: .padding(.large))
                .background(color.opacity(0.2))
                .clipShape(.circle)
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
                RefdsText(date.asString(withDateFormat: .custom("EEE")).uppercased(), style: .caption2, color: textColor, weight: .light)
                RefdsText(date.asString(withDateFormat: .custom("dd")), style: .body, color: textColor, weight: .bold)
            }
            .frame(width: 28)
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
    
    private func selectedDateBackgroundColor(with date: Date) -> Color {
        isSelectedDate(with: date) ? color : .secondary.opacity(0.1)
    }
    
    private func selectedDateTextColor(with date: Date) -> Color {
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

#Preview {
    struct ContainerView: View {
        @State var date: Date = .current
        var body: some View {
            RefdsMonthCalendar(selection: $date)
        }
    }
    return ContainerView()
}
