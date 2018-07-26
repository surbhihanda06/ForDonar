//
//  RequestExecutor.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//
import Alamofire
import ObjectMapper
import AlamofireObjectMapper


class RequestExecutor {
    
    
    static func executeRequest<T: APIRequest, U: Mappable>(_ request: T,
        completion: @escaping (_ error: Error?, _ result: U?) -> Void) {
        
        let headers = HEADERS()
        let url = URL(string: request.baseURL + request.path)!
        
        print(request.method)
        print("parameters:",request.parameters)
        print(request.encoding)
        print(url)
        //print(headers)
        Alamofire.request(url,
                          method: request.method,
                          parameters: request.parameters.isEmpty ? nil : request.parameters,
                          encoding: request.encoding,
                          headers: headers).responseString(completionHandler:{(response) in
                            print("Response: ",response.result.value ?? "No response value")
                            
                            let responseResultValue = response.result.value
                                response.result.ifSuccess {
                                    let statusCode = (response.response?.statusCode)! as Int
                                    switch(statusCode)
                                    {
                                    case 200..<400:
                                      
                                        if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                                        {
                                            if let object = Mapper<U>().map(JSONObject: jsonObject as? [String : Any])
                                            {
                                                completion(nil, object)
                                            }
                                            else
                                            {
                                                let json: [String: Any] = ["data": jsonObject]
                                                if let object = Mapper<U>().map(JSONObject: json)
                                                {
                                                    completion(nil, object)
                                                }
                                                else
                                                {
                                                    completion(response.error, nil)
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if let strResponse = responseResultValue
                                            {
                                                let json: [String: Any] = ["data": strResponse]
                                                if let object = Mapper<U>().map(JSONObject: json)
                                                {
                                                    completion(nil, object)
                                                }
                                                else
                                                {
                                                    completion(response.error, nil)
                                                }
                                            }
                                            else
                                            {
                                                completion(response.error, nil)
                                            }
                                            
                                        }
                                        
                                        break
                                    case 400..<499:
                                        if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                                        {
                                            if let object = Mapper<U>().map(JSONObject: jsonObject as? [String : Any])
                                            {
                                                completion(nil, object)
                                            }
                                            /*
                                            if let APISuccess = Mapper<APIError>().map(JSONObject: jsonObject as? [String : Any])
                                            {
                                                let msg:String = APISuccess.getError()!
                                                let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                                completion(err,nil)
                                            }*/
                                            else
                                            {
                                                completion(response.error, nil)
                                            }
                                        }
                                        else
                                        {
                                            if let strResponse = responseResultValue
                                            {
                                                let json: [String: Any] = ["message": strResponse]
                                                if let APISuccess = Mapper<APIError>().map(JSONObject: json)
                                                {
                                                    let msg:String = APISuccess.getError()!
                                                    let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                                    completion(err,nil)
                                                }
                                                else
                                                {
                                                    completion(response.error, nil)
                                                }
                                            }
                                            else
                                            {
                                                completion(response.error, nil)
                                            }
                                            
                                        }
                                        break
                                        
                                    default:
                                        if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                                        {
                                            if let APISuccess = Mapper<APIError>().map(JSONObject: jsonObject as? [String : Any])
                                            {
                                                let msg:String = APISuccess.getError()!
                                                let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                                completion(err,nil)
                                            }
                                            else
                                            {
                                                completion(response.error, nil)
                                            }
                                        }
                                        else
                                        {
                                            if let strResponse = responseResultValue
                                            {
                                                let json: [String: Any] = ["message": strResponse]
                                                if let APISuccess = Mapper<APIError>().map(JSONObject: json)
                                                {
                                                    let msg:String = APISuccess.getError()!
                                                    let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                                    completion(err,nil)
                                                }
                                                else
                                                {
                                                    completion(response.error, nil)
                                                }
                                            }
                                            else
                                            {
                                                completion(response.error, nil)
                                            }
                                            
                                        }
                                        break
                                    }
                                    
                                }
                                response.result.ifFailure{
                                    
                                    /*if let err = response.error as? URLError, err.code == .notConnectedToInternet {
                                     // no internet connection
                                     print(err)
                                     } else {
                                     // other failures
                                     }*/
                                    
                                    completion(response.error, nil)
                                }
                          })
    }
    
    static func uploadRequest<T: APIRequest, U: Mappable>(_ request: T,
                              completion: @escaping (_ error: Error?, _ result: U?) -> Void) {
        
        let headers = HEADERS()
        let url = URL(string: request.baseURL + request.path)!
        //let headers = Constants.HEADERS(bSesId: request.isAuthorized)
        //let url = request.baseURL + request.path
        
        print(request.method)
        print(request.parameters)
        print(request.encoding)
        print(url)
        
        //let image = UIImage.init(named: "myImage")
        //let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        //Alamofire.upload
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            for (key, value) in request.parameters
            {
                if let file = value as? UIImage
                {
                    let name = "image_" + fileNameWithExtnsn(extnsn: "jpg")
                    let imgData = UIImageJPEGRepresentation(file, 0.5)!
                    multipartFormData.append(imgData, withName: key,fileName: name, mimeType: "image/jpg")
                }
                else if let filePath = value as? NSURL
                {
                    var myData: NSData?
                    do {
                        myData = try NSData(contentsOfFile: (filePath.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
                        let extensn = filePath.pathExtension
                        if extensn == "jpg"
                        {
                            let name = "image_" + fileNameWithExtnsn(extnsn: "jpg")
                            multipartFormData.append(Data(referencing: myData!), withName: key,fileName: name, mimeType: "image/jpg")
                        }
                        else
                        {
                            let name = "video_" + fileNameWithExtnsn(extnsn: "mov")
                            multipartFormData.append(Data(referencing: myData!), withName: key,fileName: name, mimeType: "multipart/form-data")
                        }
                        
                    } catch _ {
                        myData = nil
                    }
                }
                else if let filePaths = value as? [NSURL]
                {
                    for filePath in filePaths
                    {
                        var myData: NSData?
                        do {
                            myData = try NSData(contentsOfFile: (filePath.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
                            let extensn = filePath.pathExtension
                            if extensn == "jpg"
                            {
                                let name = "image_" + fileNameWithExtnsn(extnsn: "jpg")
                                multipartFormData.append(Data(referencing: myData!), withName: key,fileName: name, mimeType: "image/jpg")
                            }
                            else
                            {
                                let name = "video_" + fileNameWithExtnsn(extnsn: "mov")
                                multipartFormData.append(Data(referencing: myData!), withName: key,fileName: name, mimeType: "multipart/form-data")
                            }
                            
                        } catch _ {
                            myData = nil
                        }
                    }
                    
                }
                else if let strValue = value as? String
                {
                    multipartFormData.append((strValue as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, to:url,
           headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseString(completionHandler:{(response) in
                    print("Response: ",response.result.value ?? "No response value")
                    
                    let responseResultValue = response.result.value
                    response.result.ifSuccess {
                        let statusCode = (response.response?.statusCode)! as Int
                        switch(statusCode)
                        {
                        case 200..<400:
                            
                            if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                            {
                                if let object = Mapper<U>().map(JSONObject: jsonObject as? [String : Any])
                                {
                                    completion(nil, object)
                                }
                                else
                                {
                                    let json: [String: Any] = ["data": jsonObject]
                                    if let object = Mapper<U>().map(JSONObject: json)
                                    {
                                        completion(nil, object)
                                    }
                                    else
                                    {
                                        completion(response.error, nil)
                                    }
                                }
                            }
                            else
                            {
                                if let strResponse = responseResultValue
                                {
                                    let json: [String: Any] = ["data": strResponse]
                                    if let object = Mapper<U>().map(JSONObject: json)
                                    {
                                        completion(nil, object)
                                    }
                                    else
                                    {
                                        completion(response.error, nil)
                                    }
                                }
                                else
                                {
                                    completion(response.error, nil)
                                }
                                
                            }
                            
                            break
                        case 400..<499:
                            if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                            {
                                if let APISuccess = Mapper<APIError>().map(JSONObject: jsonObject as? [String : Any])
                                {
                                    let msg:String = APISuccess.getError()!
                                    let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                    completion(err,nil)
                                }
                                else
                                {
                                    completion(response.error, nil)
                                }
                            }
                            else
                            {
                                if let strResponse = responseResultValue
                                {
                                    let json: [String: Any] = ["message": strResponse]
                                    if let APISuccess = Mapper<APIError>().map(JSONObject: json)
                                    {
                                        let msg:String = APISuccess.getError()!
                                        let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                        completion(err,nil)
                                    }
                                    else
                                    {
                                        completion(response.error, nil)
                                    }
                                }
                                else
                                {
                                    completion(response.error, nil)
                                }
                                
                            }
                            break
                            
                        default:
                            if let jsonObject = toJSON(strJSONStr: responseResultValue ?? "")
                            {
                                if let APISuccess = Mapper<APIError>().map(JSONObject: jsonObject as? [String : Any])
                                {
                                    let msg:String = APISuccess.getError()!
                                    let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                    completion(err,nil)
                                }
                                else
                                {
                                    completion(response.error, nil)
                                }
                            }
                            else
                            {
                                if let strResponse = responseResultValue
                                {
                                    let json: [String: Any] = ["message": strResponse]
                                    if let APISuccess = Mapper<APIError>().map(JSONObject: json)
                                    {
                                        let msg:String = APISuccess.getError()!
                                        let err = DDSError(title: "APIError", description: msg, code: statusCode)
                                        completion(err,nil)
                                    }
                                    else
                                    {
                                        completion(response.error, nil)
                                    }
                                }
                                else
                                {
                                    completion(response.error, nil)
                                }
                                
                            }
                            break
                        }
                        
                    }
                    response.result.ifFailure{
                        /*if let err = response.error as? URLError, err.code == .notConnectedToInternet {
                         // no internet connection
                         print(err)
                         } else {
                         // other failures
                         }*/
                        
                        completion(response.error, nil)
                    }
                })
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    
    class func toJSON(strJSONStr: String) -> Any? {
        guard let data = strJSONStr.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


