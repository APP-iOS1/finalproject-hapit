//
//  ProfileView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct ProfileCellView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var nickName = ""
    @State private var email = ""
    @State private var isSelectedJelly = 0
    @State private var showBearModal = false
    @State private var showNicknameModal = false
    let bearArray = Jelly.allCases.map({"\($0)"})
    
    var body: some View {
        VStack {
            HStack {
                // MARK: 프로필 사진 변경
                VStack {
                    Button {
                        showBearModal.toggle()
                    } label: {
                        Image(bearArray[isSelectedJelly % 7])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 60)
                            .background(Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 90, height: 90))
                    }
                    .padding(30)
                }.halfSheet(showSheet: $showBearModal) {
                    BearModalView(showModal: $showBearModal, isSelectedJelly: $isSelectedJelly)
                }
                
                // MARK: 닉네임, 이메일, 닉네임 수정
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(nickName)")
                                .font(.custom("IMHyemin-Bold", size: 22))
                                .padding(.leading, -5)
                            
                            Text("\(email)")
                                .font(.custom("IMHyemin-Regular", size: 12))
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                    
                    Button {
                        showNicknameModal = true
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke()
                            .frame(width: 210, height: 25)
                            .overlay{
                                Text("닉네임 수정")
                                    .font(.custom("IMHyemin-Bold", size: 13))
                                    .foregroundColor(.accentColor)
                                    
                            }
                    }
                    .halfSheet(showSheet: $showNicknameModal) {
                        NicknameModalView(showModal: $showNicknameModal, userNickname: $nickName)
                            .environmentObject(authManager)
                    }
                }
            }
            .padding(10)
        }
        .background()
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.top)
        .task {
            nickName = await authManager.getNickName(uid: currentUser?.uid ?? "")
            email = await authManager.getEmail(uid: currentUser?.uid ?? "")
            
        }
    }
}

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView) -> some View {
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            // closing view when showSheet toggled again
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    // On Dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
        }

    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        
        if let presentationController = presentationController as?
            UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            
        }
    }
}

struct ProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCellView()
    }
}
