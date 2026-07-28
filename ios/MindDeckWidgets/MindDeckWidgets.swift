import SwiftUI
import WidgetKit

private enum WidgetStorage {
  static let suiteName = "group.app.minddeck.minddeck"
  static let kind = "MindDeckQuickStudy"

  static func snapshot() -> MindDeckEntry {
    let defaults = UserDefaults(suiteName: suiteName)
    return MindDeckEntry(
      date: Date(),
      deckId: defaults?.string(forKey: "deckId") ?? "",
      deckTitle: defaults?.string(forKey: "deckTitle") ?? "Your next idea",
      dueCardCount: max(0, defaults?.integer(forKey: "dueCardCount") ?? 0),
      samplePrompt:
        defaults?.string(forKey: "samplePrompt")
        ?? "Open MindDeck and choose a deck"
    )
  }
}

private struct MindDeckEntry: TimelineEntry {
  let date: Date
  let deckId: String
  let deckTitle: String
  let dueCardCount: Int
  let samplePrompt: String

  var studyURL: URL? {
    guard !deckId.isEmpty else { return URL(string: "minddeck://") }
    var components = URLComponents()
    components.scheme = "minddeck"
    components.host = "study"
    components.path = "/\(deckId)"
    return components.url
  }
}

private struct MindDeckProvider: TimelineProvider {
  func placeholder(in context: Context) -> MindDeckEntry {
    MindDeckEntry(
      date: Date(),
      deckId: "languages",
      deckTitle: "Spanish basics",
      dueCardCount: 7,
      samplePrompt: "Hola"
    )
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (MindDeckEntry) -> Void
  ) {
    completion(context.isPreview ? placeholder(in: context) : WidgetStorage.snapshot())
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<MindDeckEntry>) -> Void
  ) {
    let entry = WidgetStorage.snapshot()
    let nextRefresh = Calendar.current.date(
      byAdding: .minute,
      value: 30,
      to: Date()
    ) ?? Date().addingTimeInterval(1800)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }
}

private struct MindDeckWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: MindDeckEntry

  var body: some View {
    Link(destination: entry.studyURL ?? URL(string: "minddeck://")!) {
      HStack(spacing: family == .systemMedium ? 16 : 0) {
        content
        if family == .systemMedium {
          studyButton
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
          .stroke(Color.mindDeckInk, lineWidth: 2)
      }
    }
    .widgetPaperBackground()
  }

  private var content: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(entry.deckTitle)
        .font(.system(size: 13, weight: .bold, design: .rounded))
        .foregroundStyle(Color.mindDeckInk)
        .lineLimit(1)

      Spacer(minLength: 0)

      Text(entry.samplePrompt)
        .font(
          .system(
            size: family == .systemMedium ? 24 : 21,
            weight: .bold,
            design: .rounded
          )
        )
        .foregroundStyle(Color.mindDeckInk)
        .lineLimit(2)
        .minimumScaleFactor(0.75)

      Spacer(minLength: 0)

      Text(dueLabel)
        .font(.system(size: 13, weight: .bold, design: .rounded))
        .foregroundStyle(Color.mindDeckViolet)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
  }

  private var studyButton: some View {
    VStack {
      Spacer()
      Image(systemName: "arrow.right")
        .font(.system(size: 18, weight: .bold))
        .foregroundStyle(Color.mindDeckCream)
        .frame(width: 46, height: 46)
        .background(Color.mindDeckViolet)
        .clipShape(Circle())
        .overlay {
          Circle().stroke(Color.mindDeckInk, lineWidth: 2)
        }
      Text("Study")
        .font(.system(size: 12, weight: .bold, design: .rounded))
        .foregroundStyle(Color.mindDeckInk)
      Spacer()
    }
  }

  private var dueLabel: String {
    entry.dueCardCount == 1
      ? "1 card due"
      : "\(entry.dueCardCount) cards due"
  }
}

private extension View {
  @ViewBuilder
  func widgetPaperBackground() -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) {
        Color.mindDeckCream
      }
    } else {
      background(Color.mindDeckCream)
    }
  }
}

private extension Color {
  static let mindDeckCream = Color(
    red: 255 / 255,
    green: 249 / 255,
    blue: 236 / 255
  )
  static let mindDeckInk = Color(
    red: 37 / 255,
    green: 35 / 255,
    blue: 38 / 255
  )
  static let mindDeckViolet = Color(
    red: 105 / 255,
    green: 71 / 255,
    blue: 237 / 255
  )
}

private struct MindDeckQuickStudyWidget: Widget {
  let kind = WidgetStorage.kind

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: MindDeckProvider()) { entry in
      MindDeckWidgetView(entry: entry)
    }
    .configurationDisplayName("Quick study")
    .description("See what is due and jump into your next review.")
    .supportedFamilies([.systemSmall, .systemMedium])
    .contentMarginsDisabled()
  }
}

@main
struct MindDeckWidgetBundle: WidgetBundle {
  var body: some Widget {
    MindDeckQuickStudyWidget()
  }
}
