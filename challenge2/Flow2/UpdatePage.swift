//
//  UpdatePage.swift
//  challenge2
//
//  Created by jiwon on 4/15/25.
//

import PhotosUI
import SwiftUI

struct UpdatePage: View {

    @Binding var path: NavigationPath

    let ball: Ball

    @State private var updateText: String = ""
    @State private var selectPic: PhotosPickerItem? = nil
    @State private var pic: Image? = nil
    @State private var picData: Data? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .cpink, .cblue,
                ]), startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer()
                Text(
                    "\(ball.createDate)"
                ).foregroundColor(.ctext).font(
                    .system(size: 24, weight: .bold))
                Spacer().frame(height: 50)
                PhotosPicker(selection: $selectPic, matching: .images) {
                    ZStack {

                        if let image = pic {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 169)
                                .cornerRadius(10)
                        } else if let uiImage = UIImage(data: ball.image) {
                            Image(uiImage: uiImage).resizable().scaledToFit()
                                .frame(
                                    width: 250
                                ).cornerRadius(15)
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
                        } else {
                        }
                    }
                }
                TextField(text: $updateText, axis: .vertical) {
                    Text("\(ball.content)")
                }.padding(
                    EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
                ).frame(width: 315, height: 191, alignment: .topLeading)
                    .background(.cwhite.opacity(0.7)).cornerRadius(
                        10)
                Spacer().frame(height: 70)
                Button("감사 저장소로 보내기") {
                    if !updateText.isEmpty {
                        ball.content = updateText
                    }
                    if let newPic = picData {
                        ball.image = newPic
                    }
                    path.append(Path.doneUpdate(ball))
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
}

//#Preview {
//    UpdatePage()
//}

//#Preview {
//    UpdatePage(path2: .constant(NavigationPath()))
//}

#Preview {
    let sampleImage = UIImage(systemName: "photo")!
    let imageData = sampleImage.jpegData(compressionQuality: 1.0) ?? Data()

    let dummyBall = Ball(
        createDate: "2025-04-15",
        image: imageData,
        content: "기존 감사 내용입니다.",
        openDate: Date(),  // 현재 시간 사용
        isOpen: false
    )

    return UpdatePage(
        path: .constant(NavigationPath()),
        ball: dummyBall
    )
}
