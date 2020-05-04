//
//  chooseImage.swift
//  custom_util_plugin
//
//  Created by 钟毅 on 2019/9/26.
//
import Flutter
import Foundation
import AVFoundation
class chooseImage: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    private var _viewController:UIViewController!;
    private var _result:FlutterResult!;
    init(viewController:UIViewController,result: @escaping FlutterResult) {
        super.init();
        self._viewController = viewController;
        self._result = result;
    }
    
    func checkImageAccess(type:UIImagePickerController.SourceType){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            self.pickImage(type: type);
        }else{
            AVCaptureDevice.requestAccess(for: .metadata) { (granted) in
                if granted {
                    self.pickImage(type: type);
                }
            }
        }
    }
    
    func pickImage(type:UIImagePickerController.SourceType) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.delegate = self
        //照片是否可以编辑
        imagePicker.allowsEditing = true
        //imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary 从相册选择照片
        imagePicker.sourceType = type //拍照
        //前置照相头是否可用，可用即使用前置摄像头，否则使用后置摄像头
        //        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
        //            imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front;
        //        } else {
        //            imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear;
        //        }
        //跳转到拍照界面或相册
        _viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            _viewController.dismiss(animated: true) {
                if #available(iOS 11.0, *) {
                    if let url = info[UIImagePickerController.InfoKey.imageURL.rawValue] as? URL {
                        self._result(url.absoluteString);
                    }
                } else {
                if let url = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL {
                    self._result(url.absoluteString);
                }
                    // Fallback on earlier versions
                }
            }
    }
}
