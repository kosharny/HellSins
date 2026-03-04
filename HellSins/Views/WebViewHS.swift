import SwiftUI
import WebKit

struct WebViewHS: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = UIColor(Color(hex: "#0F0F12"))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct WebContainerViewHS: View {
    let urlString: String
    @Binding var path: NavigationPath
    @EnvironmentObject var vm: ViewModelHS

    var body: some View {
        ZStack {
            InfernoBackgroundHS()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(vm.currentTheme.primaryColor)
                    }
                    Spacer()
                    Text("Psychology Video")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(vm.currentTheme.primaryColor)
                    .opacity(0)
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(hex: "#0F0F12").opacity(0.9))

                if let url = URL(string: urlString) {
                    WebViewHS(url: url)
                } else {
                    Text("Invalid URL")
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

#Preview {
    WebContainerViewHS(urlString: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", path: .constant(NavigationPath()))
        .environmentObject(ViewModelHS())
}
