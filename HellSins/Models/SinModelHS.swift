import Foundation

enum SinTypeHS: String, CaseIterable, Codable, Identifiable {
    case pride = "Pride"
    case greed = "Greed"
    case lust = "Lust"
    case envy = "Envy"
    case gluttony = "Gluttony"
    case wrath = "Wrath"
    case sloth = "Sloth"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .pride: return "crown.fill"
        case .greed: return "dollarsign.circle.fill"
        case .lust: return "heart.fill"
        case .envy: return "eye.fill"
        case .gluttony: return "fork.knife"
        case .wrath: return "flame.fill"
        case .sloth: return "moon.zzz.fill"
        }
    }

    var tagline: String {
        switch self {
        case .pride: return "Excessive belief in your own abilities"
        case .greed: return "Desire for material wealth or gain"
        case .lust: return "Intense longing or compulsive craving"
        case .envy: return "Desire for others' traits or possessions"
        case .gluttony: return "Overindulgence and overconsumption"
        case .wrath: return "Uncontrolled feelings of anger"
        case .sloth: return "Physical and spiritual laziness"
        }
    }

    var color: String {
        switch self {
        case .pride: return "#FFD60A"
        case .greed: return "#34C759"
        case .lust: return "#FF2D55"
        case .envy: return "#30D158"
        case .gluttony: return "#FF9F0A"
        case .wrath: return "#FF3B30"
        case .sloth: return "#636366"
        }
    }
}

struct SinModelHS: Identifiable, Codable {
    var id: SinTypeHS
    var masteryLevel: Int
    var progress: Double

    init(id: SinTypeHS, masteryLevel: Int = 0, progress: Double = 0.0) {
        self.id = id
        self.masteryLevel = masteryLevel
        self.progress = progress
    }
}

struct SinTestQuestionHS: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct SinTestHS {
    let sinType: SinTypeHS
    let questions: [SinTestQuestionHS]

    static func test(for sin: SinTypeHS) -> SinTestHS {
        switch sin {
        case .pride:
            return SinTestHS(sinType: .pride, questions: [
                SinTestQuestionHS(question: "How often do you seek validation from others?", options: ["Never", "Sometimes", "Often", "Always"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you often believe you are better than others?", options: ["Never", "Rarely", "Sometimes", "Frequently"], correctIndex: 0),
                SinTestQuestionHS(question: "How do you react to criticism?", options: ["I reflect on it", "I ignore it", "I feel defensive", "I reject it entirely"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you take credit for group successes?", options: ["Never", "Rarely", "Sometimes", "Always"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you compare yourself positively to others?", options: ["Rarely", "Sometimes", "Often", "All the time"], correctIndex: 0)
            ])
        case .greed:
            return SinTestHS(sinType: .greed, questions: [
                SinTestQuestionHS(question: "Do you feel satisfied with what you own?", options: ["Yes, always", "Mostly", "Rarely", "Never"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you make impulsive purchases?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you feel anxious when others have more than you?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you share resources with others?", options: ["Freely", "When asked", "Reluctantly", "Never"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you set financial goals?", options: ["Yes, regularly", "Sometimes", "Rarely", "Never"], correctIndex: 0)
            ])
        case .lust:
            return SinTestHS(sinType: .lust, questions: [
                SinTestQuestionHS(question: "Do you act impulsively on desires?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do urges override your intentions?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "Can you delay gratification effectively?", options: ["Yes, always", "Usually", "Sometimes", "Rarely"], correctIndex: 0),
                SinTestQuestionHS(question: "Do cravings disrupt your daily routine?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you reflect before reacting to a craving?", options: ["Always", "Often", "Sometimes", "Never"], correctIndex: 0)
            ])
        case .envy:
            return SinTestHS(sinType: .envy, questions: [
                SinTestQuestionHS(question: "Do you feel happy when others succeed?", options: ["Yes, genuinely", "Mostly", "Sometimes", "Rarely"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you compare your life to others?", options: ["Rarely", "Sometimes", "Often", "Constantly"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you feel resentful of other's achievements?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "Do social media feeds affect your mood negatively?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you feel what you have is enough?", options: ["Always", "Often", "Sometimes", "Rarely"], correctIndex: 0)
            ])
        case .gluttony:
            return SinTestHS(sinType: .gluttony, questions: [
                SinTestQuestionHS(question: "Do you eat beyond fullness regularly?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you binge on entertainment?", options: ["Rarely", "Sometimes", "Often", "Daily"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you maintain consistent routines?", options: ["Yes, always", "Usually", "Sometimes", "Rarely"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you consume more than needed?", options: ["Rarely", "Sometimes", "Often", "Always"], correctIndex: 0),
                SinTestQuestionHS(question: "Can you stop an enjoyable activity when needed?", options: ["Yes, easily", "Usually", "Sometimes", "Rarely"], correctIndex: 0)
            ])
        case .wrath:
            return SinTestHS(sinType: .wrath, questions: [
                SinTestQuestionHS(question: "How often do you lose your temper?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you hold grudges for long periods?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How quickly do you forgive?", options: ["Quickly", "In time", "With difficulty", "Rarely"], correctIndex: 0),
                SinTestQuestionHS(question: "Do minor annoyances ruin your day?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "How do you handle conflict?", options: ["Calmly discuss", "Withdraw", "Get loud", "Explode"], correctIndex: 0)
            ])
        case .sloth:
            return SinTestHS(sinType: .sloth, questions: [
                SinTestQuestionHS(question: "Do you complete tasks before deadlines?", options: ["Always", "Usually", "Rarely", "Never"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do you procrastinate?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you feel motivated daily?", options: ["Yes, always", "Usually", "Sometimes", "Rarely"], correctIndex: 0),
                SinTestQuestionHS(question: "How often do avoided tasks cause stress?", options: ["Rarely", "Sometimes", "Often", "Always"], correctIndex: 0),
                SinTestQuestionHS(question: "Do you prioritize rest over responsibilities?", options: ["Never", "Rarely", "Sometimes", "Often"], correctIndex: 0)
            ])
        }
    }
}
