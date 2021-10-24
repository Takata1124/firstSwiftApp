//
//  SettingViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit



class SettingViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var newText: UITextField!
//    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var imagePicture: UIImageView!
    
    
    let viewclass = ViewController()
    
    let defaults = UserDefaults.standard
    var saveArray: Array! = [NSData]()
//    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello")
        
        navbar?.delegate = self
        newText.delegate = viewclass            
//        viewclass.Printfunc()
        // Do any additional setup after loading the view.
        
        navbar.items![0].title = "Setting"
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar.isTranslucent = true
        navbar.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
        

    }
    
    
    @IBAction func backbutton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func photoButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action) in
                
//                print("カメラは利用できます")
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photolibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action) in
                
//                print("フォトライブラリーは利用できます")
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            
            alertController.addAction(photolibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = view
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let i_image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        let resizeImage = i_image?.resized()
        imagePicture.image = i_image
//        sendSaveImage(i_image)
        dismiss(animated: true, completion: nil)
    }
    
//    func sendSaveImage(_ image: UIImage?) {
//       //NSData型にキャスト
//        guard let unimage = image else {return}
//        let data = unimage.pngData() as NSData?
//        if let imageData = data {
//           saveArray.append(imageData)
//           defaults.set(saveArray, forKey: "saveImage")
////           defaults.synchronize()
//        }
//        print(saveArray)
//    }
    
}

//extension UIImage {
//    func resized() -> UIImage? {
//
//        let rect = CGRect(x: 0, y: 0, width: 90, height: 195)
//
//        UIGraphicsBeginImageContext(rect.size)
//        self.draw(in: rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image!
//    }
//}
