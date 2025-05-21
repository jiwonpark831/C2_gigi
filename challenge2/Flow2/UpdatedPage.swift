//
//  UpdatedPage.swift
//  challenge2
//
//  Created by jiwon on 4/16/25.
//

import SwiftUI

struct UpdatedPage: View {

    @Binding var path: NavigationPath

    let ball: Ball

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cpink, .cblue,
                ]), startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer()
                (Text("구슬이 ").font(
                    .system(size: 20))
                    + Text("감사 저장소").font(
                        .system(size: 20, weight: .bold))
                    + Text("에 저장되었어요").font(
                        .system(size: 20))).foregroundColor(.cpurple)
                Spacer().frame(height: 30)
                VStack {
                    Spacer().frame(height: 30)
                    Text(
                        "\(ball.createDate)"
                    ).foregroundColor(.ctext).font(
                        .system(size: 24, weight: .bold))
                    Spacer().frame(height: 30)
                    if let uiImage = UIImage(data: ball.image) {
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(
                            width: 250
                        ).cornerRadius(15)
                    }
                    Spacer().frame(height: 30)
                    Text("\(ball.content)").foregroundColor(.cpurple).font(
                        .system(size: 18)
                    ).frame(width: 230)
                    Spacer().frame(height: 30)
                }.frame(width: 343, height: 550).background(
                    RoundedRectangle(cornerRadius: 30).foregroundColor(
                        .cwhite
                    ).opacity(0.7))
                Spacer().frame(height: 45)
                Button("홈으로") {
                    path.removeLast(path.count)
                }.frame(width: 315, height: 53).foregroundColor(.cwhite)
                    .background(.cpurple).cornerRadius(10).font(
                        .system(size: 20, weight: .semibold))
                Spacer()
            }
        }.ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    UpdatedPage()
//}

//#Preview {
//    UpdatedPage(path2: .constant(NavigationPath()))
//}

#Preview {
    let sampleImage = UIImage(systemName: "photo")!
    let imageData = sampleImage.jpegData(compressionQuality: 1.0) ?? Data()

    let dummyBall = Ball(
        createDate: "2025-04-16",
        image: imageData,
        content: "감사한 마음이 담긴 구슬입니다 💜",
        openDate: Date(),
        isOpen: false
    )

    return UpdatedPage(
        path: .constant(NavigationPath()),
        ball: dummyBall
    )
}
