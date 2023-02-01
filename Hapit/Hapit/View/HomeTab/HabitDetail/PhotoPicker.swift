//
//  PhotoPicker.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/30.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator (photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else {
                    // show error or alert
                    return
                }
                photoPicker.selectedImage = compressedImage
            } else {
                // return an error show an alert
            }
            picker.dismiss(animated: true)
        }
    }
}

//사용하는 부분에
//@State private var postImage = UIImage(named: "~~")

// 글에다가
// Image(uiImage: postImage)
//      .onTapGesture { isShowingPhotoPicker, content: {PhotoPicker(image: $Image) })
