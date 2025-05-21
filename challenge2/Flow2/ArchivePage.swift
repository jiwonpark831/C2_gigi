//
//  ArchivePage.swift
//  challenge2
//
//  Created by jiwon on 4/14/25.
//

import SwiftUI

struct ArchivePage: View {

    @Environment(\.modelContext) private var context

    @Binding var path: NavigationPath
    var balls: [Ball]

    let columns = [GridItem(), GridItem()]
    //    var ball = ["defaultball", "defaultball", "defaultball"]
    //    var date = ["defaultball", "defaultball", "defaultball"]

    @State private var closeTap: Bool = false

    var body: some View {

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cblue, .cpink,
                ]), startPoint: .top, endPoint: .bottom
            )
            ScrollView {
                Spacer().frame(height: 90)
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            (Text(
                                "\(UserDefaults.standard.string(forKey: "username") ?? "Guest")"
                            ).font(
                                .system(size: 24, weight: .bold))
                                + Text("님이 기록한").font(
                                    .system(size: 24))).foregroundColor(.cwhite)
                            (Text("감사의 순간").font(
                                .system(size: 24, weight: .bold))
                                + Text("을 꺼내보세요").font(
                                    .system(size: 24))).foregroundColor(.cwhite)
                        }
                        Spacer()
                    }.padding(40)
                    Spacer().frame(height: 10)
                    let i = balls.count
                    (Text("총 ").font(
                        .system(size: 16))
                        + Text("\(i)개").font(
                            .system(size: 16, weight: .bold))
                        + Text("의 구슬이 있어요").font(
                            .system(size: 16))).foregroundColor(.cpink)

                    LazyVGrid(columns: columns) {
                        ForEach(balls, id: \.self) {
                            ball in
                            VStack {
                                if ball.isOpen == true {
                                    Image("open").resizable().frame(
                                        width: 160, height: 160
                                    ).onTapGesture {
                                        path.append(Path.detail(ball))
                                    }
                                } else {
                                    Image("lock").resizable().frame(
                                        width: 160, height: 160
                                    ).onTapGesture {
                                        closeTap.toggle()
                                    }.alert(isPresented: $closeTap) {
                                        Alert(
                                            title: Text("아직 열리지 않은 구슬이에요"),
                                            message: Text(
                                                "오픈 날짜: \(ball.openDate, formatter: CreatePage.dateformat)"
                                            ))
                                    }
                                }
                                Text(
                                    ball.createDate
                                ).foregroundColor(.cwhite).font(
                                    .system(size: 14)
                                ).padding(.bottom, 30)
                            }
                        }
                    }.padding(30)
                }
            }
        }.ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left").foregroundColor(.cpink)
                        .font(.system(size: 20, weight: .semibold)).onTapGesture
                    {
                        path.removeLast()
                    }
                }
            }
    }
}
//
//#Preview {
//    ArchivePage()
//}
//
//#Preview {
//    ArchivePage(balls: balls, path2: .constant(NavigationPath()))
//}

#Preview {
    // 샘플 더미 Ball 배열
    let dummyBalls = [
        Ball(
            createDate: "2025-04-14",
            image: Data(),  // 이미지가 필요하면 샘플 Data() 넣기
            content: "감사한 하루!",
            openDate: Date(),
            isOpen: true
        ),
        Ball(
            createDate: "2025-04-13",
            image: Data(),
            content: "햇살 좋은 날!",
            openDate: Date(),
            isOpen: false
        ),
        Ball(
            createDate: "2025-04-12",
            image: Data(),
            content: "따뜻한 커피 한잔",
            openDate: Date(),
            isOpen: true
        ),
    ]

    return ArchivePage(path: .constant(NavigationPath()), balls: dummyBalls)
}
