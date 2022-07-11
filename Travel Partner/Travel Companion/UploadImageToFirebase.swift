//
//  UploadImageToFirebase.swift
//  
//
//  Created by Spencer Goldberg on 7/1/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

func saveImage(image: UIImage, completion: @escaping (URL?) -> Void) {
    if let resizedImage = image.resized(width: 720) {
        if let data = resizedImage.pngData() {
            uploadPhoto(data: data, path: "images/profiles/") { (url) in
                if let url = url {
                    completion(url)
                }
            }
        }
    }
}

// MARK: - Firebase Functions
private func uploadPhoto(data: Data, path: String, completion: @escaping (URL?) -> Void) {
    // MARK: - Firebase
    let storage = Storage.storage()
    
    let imageName = UUID().uuidString
    let storageRef = storage.reference()
    let photoRef = storageRef.child("\(path)\(imageName).png")
    
    photoRef.putData(data, metadata: nil) { metadata, error in
        photoRef.downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("image upload completed ")
                print(url!)
                completion(url)
            }
        }
    }
}

