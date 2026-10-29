import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let symbol: String
    var body: some View {
        VStack(spacing: 8) { Image(systemName: symbol).foregroundStyle(Color.accentColor); Text(value).font(.title2.bold()); Text(title).font(.caption).foregroundStyle(.secondary) }.frame(maxWidth: .infinity).padding(12).background(Color("AccentSurface"), in: RoundedRectangle(cornerRadius: 16))
    }
}
