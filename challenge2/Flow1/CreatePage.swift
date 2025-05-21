//
//  CreatePage.swift
//  challenge2
//
//  Created by jiwon on 4/14/25.
//

import PhotosUI
import SwiftUI

//따온 코드.. 분석 필요
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil,
            for: nil)
    }
}

struct CreatePage: View {

    static var today = Date()
    static var formatter = DateFormatter()
    static let dateformat: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        return format
    }()

    @State private var newText: String = ""
    @State private var selectPic: PhotosPickerItem? = nil
    @State private var pic: Image? = nil
    @State private var picData: Data? = nil

    @Binding var path: NavigationPath

    @State private var isNotFill: Bool = false

    //    @FocusState private var focus: Bool

    var cheerUp: [String] = [
        "아주 작은 것이라도 좋아요", "작은 감사가 큰 행복이 돼요", "이 순간에도 감사할 일이 있어요",
        "오늘도 감사한 마음으로 하루를 시작해요", "사소해 보여도 감사하는 마음은 소중해요", "고마움을 느끼는 당신은 참 따뜻해요",
        "감사하는 마음이 당신을 더 빛나게 해요", "오늘의 감사는 내일의 기쁨이 될 거예요", "감사할 수 있음에 감사해요",
        "작은 감사도 마음을 채우는 선물이에요",
    ]

    @State private var cheerUpText: String = ""

    var body: some View {

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cpink, .cblue,
                ]), startPoint: .top, endPoint: .bottom
            ).onTapGesture {
                self.hideKeyboard()
            }
            VStack {
                Spacer()
                Text(
                    "\(CreatePage.today, formatter: CreatePage.dateformat)"
                ).foregroundColor(.ctext).font(
                    .system(size: 24, weight: .bold))
                Spacer().frame(height: 40)
                //                let cheerUpText = cheerUp.randomElement()
                Text("\(cheerUpText ?? "아주 작은 것이라도 좋아요")").foregroundColor(
                    .ctext
                ).font(
                    .system(size: 16))
                Spacer().frame(height: 50)

                PhotosPicker(selection: $selectPic, matching: .images) {
                    ZStack {
                        Image(systemName: "photo").resizable().frame(
                            width: 71, height: 50
                        ).foregroundColor(.ctext)

                        if let image = pic {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 169)
                                .cornerRadius(10)
                        }

                    }.frame(width: 315, height: 191).background(
                        .cwhite.opacity(0.7)
                    ).cornerRadius(10)
                }
                .onChange(of: selectPic) { uploadPic in
                    Task {
                        if let data = try? await uploadPic?
                            .loadTransferable(type: Data.self),
                            let img = UIImage(data: data)
                        {
                            pic = Image(uiImage: img)
                            picData = data
                        }
                    }
                }

                TextField(text: $newText, axis: .vertical) {
                    Text("감사 내용을 입력하세요")
                }.padding(
                    EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
                )
                .frame(width: 315, height: 191, alignment: .topLeading)
                .background(.cwhite.opacity(0.7)).cornerRadius(
                    10)
                Spacer().frame(height: 60)
                Button("날짜 선택하기") {
                    if newText.isEmpty || ((picData?.isEmpty) == true)
                        || picData == nil
                    {
                        isNotFill = true
                    } else if let data = picData {
                        path.append(
                            Path.selectDate(content: newText, picData: data))
                    }
                }.frame(width: 315, height: 53).foregroundColor(.cwhite)
                    .background(.cpurple).cornerRadius(10).font(
                        .system(size: 20, weight: .semibold)
                    ).alert(isPresented: $isNotFill) {
                        Alert(
                            title: Text("감사 구슬에 들어갈 내용이 충분하지 않아요"),
                            dismissButton: .cancel(Text("ok")))
                    }
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
            }.onAppear {
                cheerUpText = cheerUp.randomElement()!
            }
        //            .onTapGesture {
        //                focus = false
        //            }
    }
}

//#Preview {
//    CreatePage()
//}

#Preview {
    CreatePage(path: .constant(NavigationPath()))
}
