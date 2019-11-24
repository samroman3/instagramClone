

import Foundation
import FirebaseStorage

class FirebaseStorageService {
    
    private let storage: Storage!
    private let storageReference: StorageReference
    private let imagesFolderReference: StorageReference
    
    
    static var profileManager = FirebaseStorageService(type: .profile)
    static var uploadManager = FirebaseStorageService(type: .upload)
    
    enum TypeOfImage {
        case profile
        case upload
    }
    
    init(type: TypeOfImage) {
        storage = Storage.storage()
        storageReference = storage.reference()
        switch type {
        case .profile:
            imagesFolderReference = storageReference.child("profileImages")
        case .upload:
            imagesFolderReference = storageReference.child("images")
        }
        
    }
    
    
    
    func storeImage(image: Data,  completion: @escaping (Result<String,Error>) -> ()) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let uuid = UUID()
        let imageLocation = imagesFolderReference.child(uuid.description)
        imageLocation.putData(image, metadata: metadata) { (responseMetadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageLocation.downloadURL { (url, error) in
                    guard error == nil else {completion(.failure(error!));return}
                    guard let url = url?.absoluteString else {completion(.failure(error!));return}
                    completion(.success(url))
                }
            }
        }
    }
    
    func getImage(url: String, completion: @escaping (Result<UIImage,Error>) -> ()) {
        imagesFolderReference.storage.reference(forURL: url).getData(maxSize: 2000000) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
    }
    
    func getUserImage(photoUrl: URL, completion: @escaping (Result<UIImage,Error>) -> ()) {
        imagesFolderReference.storage.reference(forURL: photoUrl.absoluteString).getData(maxSize: 2000000) { (data, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
    }
}
