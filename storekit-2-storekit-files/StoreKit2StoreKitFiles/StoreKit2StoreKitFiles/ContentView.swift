import SwiftUI

struct ContentView: View {
    @Environment(EntitlementManager.self) private var entitlements
    @State private var team: [Hero] = []
    @State private var showingPaywall = false

    private let freeTeamLimit = 3
    private var teamLimit: Int { entitlements.hasPremiumAccess ? .max : freeTeamLimit }
    private var canAddMore: Bool { team.count < teamLimit }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let status = entitlements.lastTransactionStatus {
                    statusBanner(status)
                }

                if !entitlements.hasPremiumAccess {
                    freeBanner
                }

                List {
                    Section(teamSectionTitle) {
                        if team.isEmpty {
                            Text("No heroes yet. Recruit from the roster below.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(team) { hero in
                                heroRow(hero, in: .team)
                            }
                            .onDelete { indexSet in
                                team.remove(atOffsets: indexSet)
                            }
                        }
                    }

                    Section("Roster") {
                        ForEach(Hero.roster.filter { !team.contains($0) }) { hero in
                            heroRow(hero, in: .roster)
                        }
                    }
                }
            }
            .navigationTitle("Pro Team Demo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingPaywall = true
                    } label: {
                        Image(systemName: entitlements.hasPremiumAccess ? "crown.fill" : "crown")
                    }
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }

    private var teamSectionTitle: String {
        if entitlements.hasPremiumAccess {
            return "Your Team (\(team.count))"
        } else {
            return "Your Team (\(team.count)/\(freeTeamLimit))"
        }
    }

    private var freeBanner: some View {
        HStack {
            Image(systemName: "crown")
            Text("Free tier · max \(freeTeamLimit) members")
            Spacer()
            Button("Unlock Pro") { showingPaywall = true }
                .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.thickMaterial)
    }

    // Ep 2 Ch 2: a tiny banner so the listener's reactions are visible — the
    // whole point of testing IAP from the simulator is being able to *see* what
    // the listener did, not infer it from changed entitlements.
    private func statusBanner(_ status: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
            Text(status)
                .font(.caption.monospaced())
                .lineLimit(2)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(.thinMaterial)
    }

    private enum HeroSection { case team, roster }

    private func heroRow(_ hero: Hero, in section: HeroSection) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(hero.name).font(.headline)
                Text("\(hero.role.rawValue) · ⚡️ \(hero.powerLevel)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            switch section {
            case .team:
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            case .roster:
                Button {
                    addHero(hero)
                } label: {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(.plain)
                .disabled(!canAddMore)
            }
        }
    }

    private func addHero(_ hero: Hero) {
        if canAddMore {
            team.append(hero)
        } else {
            showingPaywall = true
        }
    }
}

#Preview {
    ContentView()
        .environment(EntitlementManager())
}
