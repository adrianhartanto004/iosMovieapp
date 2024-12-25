import SwiftUI

public enum RedactionReason {
    case placeholder
    case confidential
    case blurred
}

struct Placeholder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Placeholder"))
            .opacity(0)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                    .padding(.vertical, 4.5)
            )
    }
}

struct Confidential: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Confidential"))
            .overlay(Color.black)
    }
}

struct Blurred: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Blurred"))
            .blur(radius: 4)
    }
}

struct Redactable: ViewModifier {
    let reason: RedactionReason?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch reason {
        case .placeholder:
            content
                .modifier(Placeholder())
        case .confidential:
            content
                .modifier(Confidential())
        case .blurred:
            content
                .modifier(Blurred())
        case nil:
            content
        }
    }
}

extension View {
    func redacted(reason: RedactionReason?) -> some View {
        modifier(Redactable(reason: reason))
    }
}
