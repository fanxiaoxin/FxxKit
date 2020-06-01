//
// FXImagePicker.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit
import MobileCoreServices

public class FXImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private var imageFinished:((UIImage)->Void)?
    private var videoFinished:((URL)->Void)?
    private var isAllowsEdit:Bool = false
    private static let `default` = FXImagePicker()
    private override init() { }
    
    ///选择图片
    public class func selectImage(_ viewController:UIViewController, allowEdit:Bool,finished:@escaping (UIImage)->Void) {
        let ip = FXImagePicker.default
        ip.imageFinished = finished
        ip.isAllowsEdit = allowEdit

        let sheet = UIAlertController(title: "选择图片", message: "请选择图片来源", preferredStyle: .actionSheet)
        // 判断是否支持相机
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let photo = UIAlertAction(title: "拍照", style: .default, handler: { (action) in
                self.takePhoto(viewController, allowEdit: allowEdit, finished: finished)
            })
            sheet.addAction(photo)
        }
        let picture = UIAlertAction(title: "从相册获取", style: .default, handler: { (action) in
            self.takePicture(viewController, allowEdit: allowEdit, finished: finished)
        })
        sheet.addAction(picture)
        let canel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(canel)
        
        viewController.present(sheet, animated: true, completion: nil)
    }
    ///直接调用相册
    public class func takePicture(_ viewController:UIViewController,allowEdit:Bool,finished:@escaping (UIImage)->Void) {
        let ip = FXImagePicker.default
        ip.imageFinished = finished
        ip.isAllowsEdit = allowEdit
        
        // 跳转到相机或相册页面
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = ip;
        imagePickerController.allowsEditing = ip.isAllowsEdit;
        imagePickerController.sourceType = .photoLibrary;
        
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    ///直接调用拍照
    public class func takePhoto(_ viewController:UIViewController,allowEdit:Bool,finished:@escaping (UIImage)->Void) {
        // 判断是否支持相机
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: "错误", message: "无法打开相机！", preferredStyle:.alert)
            viewController.present(alert, animated: true, completion: nil)
            return;
        }
        let ip = FXImagePicker.default
        ip.imageFinished = finished
        ip.isAllowsEdit = allowEdit
        
        // 跳转到相机或相册页面
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = ip;
        imagePickerController.allowsEditing = ip.isAllowsEdit;
        imagePickerController.sourceType = .camera;
        
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    ///直接调用拍视频
    public class func takeVideo(_ viewController:UIViewController, maximumDuration:TimeInterval,finished:@escaping (URL)->Void) {
        // 判断是否支持相机
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: "错误", message: "无法打开相机！", preferredStyle:.alert)
            viewController.present(alert, animated: true, completion: nil)
            return;
        }
        let ip = FXImagePicker.default
        ip.videoFinished = finished
        
        // 跳转到相机或相册页面
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = ip
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as String];
        imagePickerController.videoQuality = .typeLow;   //设置视频质量
        imagePickerController.sourceType = .camera;
        imagePickerController.cameraCaptureMode = .video;
        imagePickerController.videoMaximumDuration = maximumDuration;
        
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let ip = FXImagePicker.default
        picker.dismiss(animated: true, completion: nil)
        
        if let type = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if type == kUTTypeImage as String {
                let image:UIImage
                if ip.isAllowsEdit {
                    image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
                }else{
                    image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                }
                ip.imageFinished?(image)
                ip.imageFinished = nil
            }else if type == kUTTypeMovie as String {
                let url = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                ip.videoFinished?(url)
                ip.videoFinished = nil
            }
        }
    }
}

extension FX.NamespaceImplement where Base: UIViewController {
    ///选择图片
    public func selectImage(allowEdit:Bool = true,finished:@escaping (UIImage)->Void) {
        FXImagePicker.selectImage(self.base, allowEdit: allowEdit, finished: finished)
    }
    ///直接调用相册
    public func takePicture(allowEdit:Bool = true,finished:@escaping (UIImage)->Void) {
        FXImagePicker.takePicture(self.base, allowEdit: allowEdit, finished: finished)
    }
    ///直接调用拍照
    public func takePhoto(allowEdit:Bool = true,finished:@escaping (UIImage)->Void) {
        FXImagePicker.takePhoto(self.base, allowEdit: allowEdit, finished: finished)
    }
    ///直接调用拍视频
    public func takeVideo(maximumDuration:TimeInterval,finished:@escaping (URL)->Void) {
        FXImagePicker.takeVideo(self.base, maximumDuration: maximumDuration, finished: finished)
    }
}
