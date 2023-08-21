import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import MLYOpenApiSDK

class ViewController: UIViewController {
    let client: Client = .init(api_key: "YOUR_CLIENT_ID")
    let url: URL? = .init(string: "YOUR_SERVICE_ADDRESS")
    
    lazy var button:UIButton = .init(frame: CGRect.init(x: self.view.frame.width / 2 - (50 / 2), y: self.view.frame.height / 2, width: 55, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.initClient()
    }
    
    func setupView(){
        self.button.setTitle("选择", for: .normal)
        self.button.setTitleColor(.white, for: .normal)
        self.button.backgroundColor = .darkText
        self.button.titleLabel?.font = .systemFont(ofSize: 14)
        self.view.addSubview(self.button)
        self.button.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)
    }
    
    func initClient(){
        self.client.delegate = self
        self.client.completionHandler = { (data, response, error) in
            if let error = error {
                debugPrint("Error: \(error)")
            } else if let response = response {
                debugPrint("Response: \(response)")
            }
        }
    }
    
    @objc func buttonAction(sender:UIButton){
        self.selectFile()
    }
    
    func selectFile() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [
                (kUTTypeMovie as String),
                (kUTTypeVideo as String),
                (kUTTypeJPEG as String),
                (kUTTypePNG as String),
                (kUTTypeImage as String)
            ]
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }else{
            debugPrint("读取相册错误")
        }
    }

}

extension ViewController: ClientURLSessionDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, currentProgress: Float, currentProgressValue: Float) {
        debugPrint("\(currentProgress)%  \(currentProgressValue)")
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        debugPrint("mediaURL: \(String(describing: mediaURL))")
        debugPrint("imageURL: \(String(describing: imageURL))")
        if let url = self.url{
            if let mediaURL = mediaURL {
                self.client.uploadFile(url: url, fileUrl: mediaURL)
            }
            if let imageURL = imageURL {
                self.client.uploadFile(url: url, fileUrl: imageURL)
            }
        }
        picker.dismiss(animated: true)
    }
    
}
 
