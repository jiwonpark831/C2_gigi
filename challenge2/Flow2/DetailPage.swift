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
                VStack {
                    Spacer().frame(height: 30)
                    Text(ball.createDate).foregroundColor(.ctext).font(
                        .system(size: 24, weight: .bold))
                    Spacer().frame(height: 30)
                    if let uiImage = UIImage(data: ball.image) {
                        Image(uiImage: uiImage).resizable().scaledToFit().frame(
                            width: 250
                        ).cornerRadius(15)
                    }
                    Spacer().frame(height: 30)
                    Text(ball.content).foregroundColor(.cpurple).font(
                        .system(size: 18))
                    Spacer().frame(height: 30)
                }.frame(width: 343, height: 550).background(
                    RoundedRectangle(cornerRadius: 29).foregroundColor(
                        .cwhite
                    ).opacity(0.7))
                Spacer().frame(height: 30)
                HStack {
                    Spacer()
                    Button("수정") {
                        path.append(Path.update(ball))
                    }.frame(width: 72, height: 40).foregroundColor(.cwhite)
                        .background(.ctext).cornerRadius(10).font(
                            .system(size: 16, weight: .semibold))
                    Button("삭제") {
                        removeButton = true
                    }.frame(width: 72, height: 40).foregroundColor(.cwhite)
                        .background(.ctext).cornerRadius(10).font(
                            .system(size: 16, weight: .semibold)
                        ).padding(.leading, 18)
                        .alert(
                            "감사 구슬을 삭제할까요?", isPresented: $removeButton
                        ) {
                            Button("아니요", role: .cancel) {
                            }
                            Button("네") {
                                context.delete(ball)
                                path.removeLast()
                            }
                        }
                }.padding(.trailing, 50)
                Spacer()
            }
        }.ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left").foregroundColor(.ctext)
                        .font(.system(size: 20, weight: .semibold)).onTapGesture
                    {
                        path.removeLast()
                    }
                }
            }

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

    return DetailPage(path: .constant(NavigationPath()), ball: dummyBall)
}
