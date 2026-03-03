import SwiftUI

struct LibraryViewHS: View {
    @EnvironmentObject var vm: ViewModelHS
    @Binding var path: NavigationPath
    @State private var searchText = ""
    @State private var showFavorites = false
    @State private var expandedID: UUID? = nil

    private var displayedEntries: [LibraryEntryHS] {
        let base = showFavorites ? vm.libraryEntries.filter { $0.isFavorite } : vm.libraryEntries
        if searchText.isEmpty { return base }
        return base.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.feeling.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomHeaderHS(title: "Library", path: $path)

                searchBar
                tabPicker
                symptomTags
                articlesList

                Spacer(minLength: 120)
            }
            .padding(.horizontal, 20)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
            TextField("", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search by title or feeling…")
                        .foregroundColor(.white.opacity(0.25))
                        .font(.system(size: 14))
                }
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.35))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.07))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(["Articles", "Favorites"], id: \.self) { tab in
                let isActive = (tab == "Favorites") == showFavorites
                Button { withAnimation(.spring(response: 0.3)) { showFavorites = tab == "Favorites" } } label: {
                    VStack(spacing: 6) {
                        Text(tab)
                            .font(.system(size: 13, weight: isActive ? .bold : .medium))
                            .foregroundColor(isActive ? .white : .white.opacity(0.35))
                        Capsule()
                            .fill(isActive ? vm.currentTheme.primaryColor : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var symptomTags: some View {
        let allFeelings = ["angry", "lazy", "greedy", "jealous", "tired", "proud", "stuck"]
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(allFeelings, id: \.self) { feeling in
                    Button {
                        withAnimation { searchText = searchText == feeling ? "" : feeling }
                    } label: {
                        Text(feelingLabel(feeling))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(searchText == feeling ? .white : .white.opacity(0.55))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(searchText == feeling ? vm.currentTheme.primaryColor.opacity(0.4) : Color.white.opacity(0.07))
                            .overlay(Capsule().stroke(searchText == feeling ? vm.currentTheme.primaryColor.opacity(0.6) : Color.white.opacity(0.1), lineWidth: 0.8))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private func feelingLabel(_ f: String) -> String {
        switch f {
        case "angry": return "😤 Angry"
        case "lazy": return "😴 Lazy"
        case "greedy": return "💰 Greedy"
        case "jealous": return "👁 Envious"
        case "tired": return "⚡ Low Energy"
        case "proud": return "🦁 Proud"
        case "stuck": return "🔁 Stuck"
        default: return f.capitalized
        }
    }

    private var articlesList: some View {
        VStack(spacing: 14) {
            if displayedEntries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: showFavorites ? "heart.slash" : "magnifyingglass")
                        .font(.system(size: 36))
                        .foregroundColor(.white.opacity(0.15))
                    Text(showFavorites ? "No favorites saved yet" : "No articles match")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(displayedEntries) { entry in
                    articleCard(entry: entry)
                }
            }
        }
    }

    @ViewBuilder
    private func articleCard(entry: LibraryEntryHS) -> some View {
        let isExpanded = expandedID == entry.id

        VStack(alignment: .leading, spacing: 0) {
            if isExpanded {
                ZStack(alignment: .bottomLeading) {
                    if !entry.imageName.isEmpty {
                        Image(entry.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color(hex: "#2D0000"), Color(hex: "#0F0F12")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "book.fill")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color(hex: "#FFD60A"), Color(hex: "#FF6A00")], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                    }
                    LinearGradient(colors: [Color.clear, Color(hex: "#0F0F12").opacity(0.9)], startPoint: .top, endPoint: .bottom)
                        .frame(height: 80)
                }
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 18, topTrailingRadius: 18))
            }

            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        expandedID = isExpanded ? nil : entry.id
                    }
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Text(feelingLabel(entry.feeling))
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(vm.currentTheme.primaryColor)
                                    .tracking(0.5)
                            }
                            Text(entry.title)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            if !isExpanded {
                                Text(previewText(entry.content))
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.white.opacity(0.45))
                                    .lineSpacing(3)
                                    .lineLimit(2)
                            }
                        }
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.3))
                                .animation(.spring(response: 0.3), value: isExpanded)
                            Button {
                                vm.toggleFavorite(entry)
                            } label: {
                                Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 14))
                                    .foregroundColor(entry.isFavorite ? vm.currentTheme.primaryColor : .white.opacity(0.3))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                if isExpanded {
                    Divider().background(Color.white.opacity(0.07))
                    ScrollView(showsIndicators: false) {
                        Text(entry.content)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.82))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxHeight: 400)
                }
            }
            .padding(16)
        }
        .background(Color.white.opacity(isExpanded ? 0.08 : 0.05))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(isExpanded ? vm.currentTheme.primaryColor.opacity(0.3) : Color.white.opacity(0.07), lineWidth: isExpanded ? 1.0 : 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func previewText(_ full: String) -> String {
        let clean = full.replacingOccurrences(of: "\n", with: " ")
        return String(clean.prefix(120))
    }
}

extension View {
    func placeholder<Content: View>(when show: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeholder() }
            self
        }
    }
}

#Preview {
    ZStack {
        InfernoBackgroundHS()
        LibraryViewHS(path: .constant(NavigationPath()))
    }
    .environmentObject(ViewModelHS())
}
