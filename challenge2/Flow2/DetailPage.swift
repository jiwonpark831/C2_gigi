//
//  DetailPage.swift
//  challenge2
//
//  Created by jiwon on 4/15/25.
//

import SwiftUI

struct DetailPage: View {

    @Environment(\.modelContext) private var context

    @State private var removeButton: Bool = false
    @Binding var path2: NavigationPath

    let ball: Ball

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cpink, .cblue,
                ]), startPoint: .top, endPoint: .bottom)
            VStack {
                VStack {
                    //                    Text(
                    //                        "\(CreatePage.today, formatter: CreatePage.dateformat)"
                    //                    )
                    Text(ball.createDate).foregroundColor(.ctext).font(
                        .system(size: 24, weight: .semibold))
                    Spacer().frame(height: 30)
                    if let uiImage = UIImage(data: ball.image) {
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(
                            width: 250
                        ).cornerRadius(15)
                    }
                    Spacer().frame(height: 30)
                    Text(ball.content).foregroundColor(.cpurple).font(
                        .system(size: 18))
                }.frame(width: 343, height: 495).background(
                    RoundedRectangle(cornerRadius: 29).foregroundColor(
                        .cwhite
                    ).opacity(0.7))
                Spacer().frame(height: 30)
                HStack {
                    Spacer()
                    Button("수정") {
                        path2.append(ArchivePath.update)
                    }.frame(width: 72, height: 40).foregroundColor(.cwhite)
                        .background(.ctext).cornerRadius(10).font(
                            .system(size: 14))
                    //                        NavigationLink {
                    //                            UpdatePage()
                    //                        } label: {
                    //                            Text("수정")
                    //                        }
                    Button("삭제") {
                        removeButton = true
                    }.frame(width: 72, height: 40).foregroundColor(.cwhite)
                        .background(.ctext).cornerRadius(10).font(
                            .system(size: 14)
                        ).padding(.leading, 18).alert(
                            "감사 구슬을 삭제할까요?", isPresented: $removeButton
                        ) {
                            Button("아니요", role: .cancel) {
                            }
                            Button("네") {
                                context.delete(ball)
                                path2.removeLast()
                            }
                        }
                }.padding(.trailing, 50)
            }
        }.ignoresSafeArea(.all)
    }
}

//#Preview {
//    DetailPage()
//}

//#Preview {
//    DetailPage(path2: .constant(NavigationPath()))
//}

#Preview {
    let sampleImageData = UIImage(named: "defaultball")?.pngData() ?? Data()

    let dummyBall = Ball(
        createDate: "2025-04-15",
        image: sampleImageData,
        content: "오늘 감사했던 순간: 따뜻한 봄날 🌸",
        openDate: Date(),
        isOpen: true
    )

    return DetailPage(path2: .constant(NavigationPath()), ball: dummyBall)
}
