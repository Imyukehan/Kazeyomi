import SwiftUI

struct MangaCardView: View {
    let title: String
    let thumbnailURL: URL?
    let authorization: String?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AuthorizedAsyncImage(url: thumbnailURL, authorization: authorization) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                Rectangle()
                    .fill(.quaternary)
                    .overlay {
                        Image(systemName: "book")
                            .foregroundStyle(.secondary)
                    }
            }
            .clipped()

            LinearGradient(
                colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.25),
                    Color.black.opacity(0.7),
                ],
                startPoint: .center,
                endPoint: .bottom
            )

            Text(title)
                .font(.footnote)
                .foregroundStyle(.white)
                .lineLimit(2)
                .padding(8)
        }
        // Match Sorayomi childAspectRatio: 0.75 (width / height)
        .aspectRatio(0.75, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

#Preview {
    MangaCardView(
        title: "示例漫画标题示例漫画标题",
        thumbnailURL: nil,
        authorization: nil
    )
    .padding()
}
