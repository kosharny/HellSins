import SwiftUI

struct HeatmapCalendarHS: View {
    @EnvironmentObject var vm: ViewModelHS
    let month: Date

    private var calendar: Calendar { Calendar.current }

    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let start = calendar.date(from: calendar.dateComponents([.year, .month], from: month))
        else { return [] }
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: start) }
    }

    private var firstWeekday: Int {
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else { return 0 }
        return (calendar.component(.weekday, from: startOfMonth) + 5) % 7
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(["M","T","W","T","F","S","S"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                }
            }

            let allCells = Array(repeating: Date?.none, count: firstWeekday) + daysInMonth.map { Optional($0) }
            let rows = stride(from: 0, to: allCells.count, by: 7).map { Array(allCells[$0..<min($0+7, allCells.count)]) }

            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 4) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, date in
                        if let d = date {
                            let score = vm.activityScore(for: d)
                            let intensity = min(Double(score) / 100.0, 1.0)
                            let isToday = calendar.isDateInToday(d)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(intensity > 0 ? vm.currentTheme.primaryColor.opacity(0.2 + intensity * 0.8) : Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(isToday ? vm.currentTheme.primaryColor : Color.clear, lineWidth: 1.5)
                                )
                                .overlay(
                                    Text("\(calendar.component(.day, from: d))")
                                        .font(.system(size: 9, weight: isToday ? .bold : .medium))
                                        .foregroundColor(.white.opacity(isToday ? 1.0 : 0.5))
                                )
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    if row.count < 7 {
                        ForEach(0..<(7 - row.count), id: \.self) { _ in
                            Color.clear.frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HeatmapCalendarHS(month: Date())
        .padding()
        .background(Color(hex: "#0F0F12"))
        .environmentObject(ViewModelHS())
}
