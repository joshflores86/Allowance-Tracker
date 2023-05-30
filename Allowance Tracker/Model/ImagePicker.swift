//
//  ImagePicker.swift
//  Allowance Tracker
//
//  Created by Josh Flores on 5/25/23.
//

import SwiftUI
import UIKit



  
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage
        @Environment(\.presentationMode) var presentationMode
        
        
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.allowsEditing = true
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
            // Do nothing
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(photoPicker: self)
        }
    
        //MARK: - Class Coordinator
        
      final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let photoPicker: ImagePicker
                
            init(photoPicker: ImagePicker){
                self.photoPicker = photoPicker
            }
                
                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    if let image = info[.editedImage] as? UIImage {
                        photoPicker.image = image
                        
                    }else{
                        
                    }
                    picker.dismiss(animated: true)
                }
        
//                func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//                    parent.presentationMode.wrappedValue.dismiss()
//                }
            }
        }
    
    


