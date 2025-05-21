//
//  HomePage.swift
//  challenge2
//
//  Created by jiwon on 4/14/25.
//

import SwiftData
import SwiftUI
import UIKit

//모션감지 따와서 적용만 시켜둔거라.. 분석 필요
class ShakeDetectingViewController: UIViewController {  // UIKit의 UIViewController를 상속받은 커스텀 뷰 컨트롤러 디바이스가 흔들렸을 때 이벤트를 감지해서 외부에서 전달받은 onShake 클로저를 실행
    var onShake: (() -> Void)?

    override func motionEnded(  // 사용자가 디바이스를 흔들고 나서 동작이 끝났을 때 호출되는 UIKit의 기본 메서드
        _ motion: UIEvent.EventSubtype, with event: UIEvent?
    ) {
        if motion == .motionShake {  // 흔들기 이벤트인지 확인하는 조건
            onShake?()  // 흔들기 감지되면 외부에서 정의한 동작 실행
        }
    }
}

struct ShakeDetector: UIViewControllerRepresentable {  // SwiftUI에서는 UIViewController를 직접 사용할 수 없어서 SwiftUI에서 사용할 수 있도록 래핑
    var onShake: () -> Void  // 흔들렸을 때 실행할 동작을 SwiftUI 쪽에서 정의 가능하게 해줌

    func makeUIViewController(context: Context) -> ShakeDetectingViewController
    {
        let controller = ShakeDetectingViewController()  //     ShakeDetectingViewController 인스턴스 생성
        controller.onShake = onShake  // 연결
        return controller
    }

    func updateUIViewController(
        _ uiViewController: ShakeDetectingViewController, context: Context
    ) {}
}

struct HomePage: View {

    @Environment(\.modelContext) private var context
    @Query private var balls: [Ball]

    @Binding var path: NavigationPath
    //    @State var path2 = NavigationPath()

    private var questions: [String] = [
        "오늘은 어떤 것이 감사했나요?",
        "마음이 따뜻해진 일이 있나요?",
        "고마움을 느낀 일이 있었나요?",
        "작은 감사를 떠올려볼까요?",
        "미소 짓게 했던 것이 있나요?",
        "지금 떠오르는 감사가 있나요?",
        "작은 고마움을 기록해볼까요?",
        "오늘의 특별한 감사가 있나요?",
        "감사의 순간을 기록해보세요",
        "오늘의 감사를 남겨보세요",
    ]

    @State private var isTodayBallExist: Bool = false
    @State private var closedTodayBalls: [Ball] = []

    @State private var isShowingBallPopUp: Bool = false
    @State private var closedTodayBallCount: Int = 0
    @State private var todayBallCountIndex: Int = 0

    @State private var didOpenAllBalls: Bool = false

    @State private var isBallBouncing: Bool = true

    init(path: Binding<NavigationPath>) {
        self._path = path
    }

    var body: some View {
        ZStack {
            if !isTodayBallExist {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .cpurple, .cyellow,
                    ]),
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .cyellow, .cpurple,
                    ]),
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea(.all)
            }

            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "shippingbox.fill").resizable()
                        .frame(
                            width: 35, height: 35
                        ).foregroundColor(
                            .cwhite
                        ).onTapGesture {
                            path.append(Path.list)
                        }
                }.padding(30)
                Spacer().frame(height: 15)

                HStack {
                    VStack(alignment: .leading) {
                        (Text(
                            "\(UserDefaults.standard.string(forKey: "username") ?? "Guest")"
                        ).font(
                            .system(size: 32, weight: .bold))
                            + Text("님,").font(
                                .system(size: 32))).foregroundColor(
                                .cwhite)
                        let question = questions.randomElement()
                        if !isTodayBallExist {
                            if !didOpenAllBalls {
                                Text(
                                    "\(question ?? "오늘은 어떤 것이 감사했나요?")"
                                )
                                .foregroundColor(.cwhite)
                                .font(.system(size: 24)).frame(
                                    width: 290, alignment: .leading)
                            } else {
                                Text("감사 구슬이 빛나고 있어요").foregroundColor(
                                    .cwhite
                                )
                                .font(.system(size: 24)).frame(
                                    width: 290, alignment: .leading)
                            }
                        } else {
                            Text("오늘 열어볼 감사 구슬이 도착했어요").foregroundColor(
                                .cwhite
                            )
                            .font(.system(size: 20)).frame(
                                width: 290, alignment: .leading)
                        }
                    }
                    Spacer()
                }.padding(.leading, 35)

                Spacer().frame(height: 40)

                if !isTodayBallExist {
                    if !didOpenAllBalls {
                        Image("defaultball").resizable().frame(
                            width: 400, height: 400
                        ).scaleEffect(isBallBouncing ? 1.0 : 0.95)
                            .animation(
                                .linear(duration: 0.7).repeatForever(),
                                value: isBallBouncing
                            ).onTapGesture {
                                path.append(Path.create)
                            }
                    } else {
                        Image("openball").resizable().frame(
                            width: 400, height: 400
                        ).scaleEffect(isBallBouncing ? 1.0 : 0.95)
                            .animation(
                                .linear(duration: 0.7).repeatForever(),
                                value: isBallBouncing)
                    }
                } else {
                    ZStack {
                        Image("closeball").resizable().frame(
                            width: 400, height: 400
                        )

                        ShakeDetector {
                            isShowingBallPopUp.toggle()
                        }
                    }.fullScreenCover(
                        isPresented: $isShowingBallPopUp,
                        onDismiss: {
                            todayBallCountIndex += 1
                            if todayBallCountIndex < closedTodayBallCount {
                                isShowingBallPopUp = true
                            } else {
                                todayBallCountIndex = 0
                                isTodayBallExist = false
                                didOpenAllBalls = true
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 5
                                ) {
                                    didOpenAllBalls = false

                                }
                            }
                        }
                    ) {

                        VStack {
                            Text(
                                closedTodayBalls[todayBallCountIndex]
                                    .createDate
                            ).foregroundColor(.ctext).font(
                                .system(size: 24, weight: .bold))
                            Spacer().frame(height: 30)
                            if let uiImage = UIImage(
                                data: closedTodayBalls[todayBallCountIndex]
                                    .image)
                            {
                                Image(uiImage: uiImage).resizable()
                                    .scaledToFit().frame(
                                        width: 250
                                    ).cornerRadius(15)
                            }
                            Spacer().frame(height: 30)
                            Text(closedTodayBalls[todayBallCountIndex].content)
                                .foregroundColor(.cpurple).font(
                                    .system(size: 18))
                        }.onTapGesture {
                            closedTodayBalls[todayBallCountIndex].isOpen = true
                            isShowingBallPopUp = false
                        }.presentationBackground(.ultraThinMaterial)
                    }
                }
                Spacer().frame(height: 40)
                if !isTodayBallExist {
                    if !didOpenAllBalls {
                        (Text("구슬을 눌러 ").font(
                            .system(size: 18, weight: .bold))
                            + Text("감사한 일을 기록해보세요").font(
                                .system(size: 18)))
                            .foregroundColor(
                                .cwhite)
                    } else {
                        Text("오늘도 감사가 넘치는 하루 보내세요").font(
                            .system(size: 18)
                        )
                        .foregroundColor(
                            .cwhite)
                    }
                } else {
                    (Text("핸드폰을 ").font(.system(size: 18)))
                        .foregroundColor(
                            .cwhite)
                        + Text("흔들어 ").font(
                            .system(size: 18, weight: .bold)
                        ).foregroundColor(
                            .cwhite)
                        + Text("구슬을 열어보세요").font(.system(size: 18))
                        .foregroundColor(
                            .cwhite)
                }
                Spacer()
            }

        }
        .onAppear {
            isBallBouncing = true
            closedTodayBalls = balls.filter {
                Calendar.current.isDate(
                    $0.openDate, inSameDayAs: Date()) && !$0.isOpen
            }
            closedTodayBallCount = closedTodayBalls.count
            isTodayBallExist = !closedTodayBalls.isEmpty
        }
    }
}

#Preview {
    HomePage(path: .constant(NavigationPath())).modelContainer(
        for: Ball.self, inMemory: true)
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Ball.self, configurations: config)
//
//    // 샘플 이미지 (시스템 이미지로 대체)
//    let sampleImage = UIImage(systemName: "heart.fill")!
//    let imageData = sampleImage.jpegData(compressionQuality: 0.8)!
//
//    // 오늘 날짜
//    let today = Date()
//
//    var dummyBalls = [
//        Ball(
//            createDate: "2025-04-20",
//            image: imageData,
//            content: "햇살 좋은 날 산책해서 기분이 좋았어요!",
//            openDate: today,
//            isOpen: false
//        ),
//        Ball(
//            createDate: "2025-04-20",
//            image: imageData,
//            content: "친구가 고마운 말을 해줘서 마음이 따뜻했어요.",
//            openDate: today,
//            isOpen: false
//        ),
//    ]
//
//    for ball in dummyBalls {
//        container.mainContext.insert(ball)
//    }
//
//    return HomePage()
//        .modelContainer(container)
//}
