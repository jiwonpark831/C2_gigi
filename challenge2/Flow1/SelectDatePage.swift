//
//  SelectDatePage.swift
//  challenge2
//
//  Created by jiwon on 4/14/25.
//

import SwiftUI

struct SelectDatePage: View {

    @Environment(\.modelContext) private var context

    //    @State private var isComplete = false
    @State private var selectDate = Date()
    @Binding var path: NavigationPath

    let content: String
    let picData: Data

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cpink, .cblue,
                ]), startPoint: .top, endPoint: .bottom)

            VStack {
                Spacer()
                Text("감사 구슬을 언제 다시 열어볼까요?").foregroundColor(.cpurple).font(
                    .system(size: 20, weight: .semibold))
                Spacer().frame(height: 50)
                DatePicker(
                    "", selection: $selectDate,
                    displayedComponents: [.date]
                ).datePickerStyle(.graphical).environment(
                    \.locale, .init(identifier: "ko_KR")
                ).tint(.cpurple)
                Spacer().frame(height: 70)
                Button("감사 저장소로 보내기") {
                    //                        isComplete = true
                    createBall()
                    path.append(
                        Path.doneBall(content: content, picData: picData))
                }.frame(width: 315, height: 53).foregroundColor(.cwhite)
                    .background(.cpurple).cornerRadius(10).font(
                        .system(size: 20, weight: .semibold))
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
    private func createBall() {
        let createDate = CreatePage.dateformat.string(from: CreatePage.today)
        let newBall = Ball(
            createDate:
                createDate, image: picData, content: content,
            openDate: selectDate,
            isOpen: false)
        context.insert(newBall)
    }

}

//
//#Preview {
//    SelectDatePage()
//}

//#Preview {
//    SelectDatePage(path: .constant(NavigationPath()))
//}

#Preview {
    SelectDatePage(
        path: .constant(NavigationPath()),
        content: "오늘의 감사: 따뜻한 햇살과 맛있는 커피",
        picData: UIImage(systemName: "heart.fill")!.jpegData(
            compressionQuality: 1.0)!
    )
}
