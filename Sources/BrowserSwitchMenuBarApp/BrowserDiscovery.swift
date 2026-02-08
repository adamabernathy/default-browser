import Foundation

struct BrowserCandidateInfo: Equatable {
    let bundleID: String
    let appURL: URL
    let displayName: String
}

enum BrowserDiscovery {
    static func orderedBundleIDs(
        preferredOrder: [String],
        candidates: [BrowserCandidateInfo],
        homeDirectory: String = NSHomeDirectory()
    ) -> [String] {
        let deduplicated = deduplicateByDisplayName(candidates, homeDirectory: homeDirectory)
        let deduplicatedIDs = Set(deduplicated.map(\.bundleID))

        let preferred = preferredOrder.filter { deduplicatedIDs.contains($0) }
        let others = deduplicated
            .filter { !preferredOrder.contains($0.bundleID) }
            .sorted {
                let nameCompare = $0.displayName.localizedCaseInsensitiveCompare($1.displayName)
                if nameCompare != .orderedSame { return nameCompare == .orderedAscending }
                return $0.bundleID.localizedCaseInsensitiveCompare($1.bundleID) == .orderedAscending
            }
            .map(\.bundleID)

        return preferred + others
    }

    static func deduplicateByDisplayName(
        _ candidates: [BrowserCandidateInfo],
        homeDirectory: String = NSHomeDirectory()
    ) -> [BrowserCandidateInfo] {
        var bestByName: [String: BrowserCandidateInfo] = [:]

        for candidate in candidates {
            let key = candidate.displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let normalizedKey = key.isEmpty ? candidate.bundleID : key

            guard let existing = bestByName[normalizedKey] else {
                bestByName[normalizedKey] = candidate
                continue
            }

            if isPreferredInstallLocation(candidate.appURL, over: existing.appURL, homeDirectory: homeDirectory) {
                bestByName[normalizedKey] = candidate
            }
        }

        return Array(bestByName.values)
    }

    static func isPreferredInstallLocation(
        _ lhs: URL,
        over rhs: URL,
        homeDirectory: String = NSHomeDirectory()
    ) -> Bool {
        let lhsRank = installLocationRank(lhs, homeDirectory: homeDirectory)
        let rhsRank = installLocationRank(rhs, homeDirectory: homeDirectory)
        if lhsRank != rhsRank { return lhsRank < rhsRank }
        if lhs.path.count != rhs.path.count { return lhs.path.count < rhs.path.count }
        return lhs.path.localizedCaseInsensitiveCompare(rhs.path) == .orderedAscending
    }

    static func installLocationRank(_ url: URL, homeDirectory: String = NSHomeDirectory()) -> Int {
        let path = url.path
        if path.hasPrefix("/Applications/") { return 0 }
        if path.hasPrefix("\(homeDirectory)/Applications/") { return 1 }
        return 2
    }
}
