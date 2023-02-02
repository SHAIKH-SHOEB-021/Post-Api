//
//  ViewController.swift
//  Post Api
//
//  Created by shoeb on 02/02/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func postBTN(_ sender: Any) {
        self.setupPostMethod()
    }
}

extension ViewController{
    func setupPostMethod(){
        guard let titleTT = self.titleTF.text else { return }
        guard let priceTT = self.priceTF.text else { return }
        guard let brandTT = self.brandTF.text else { return }
        
        if let url = URL(string: "https://dummyjson.com/products/add"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameter : [String : Any] = ["title" : titleTT, "price" : priceTT, "brand" : brandTT]
            request.httpBody = parameter.percentEscaped().data(using: .utf8)
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard let data = data else {
                    if error == nil{
                        print("\(String(describing: error?.localizedDescription)) Error")
                    }
                    return
                }
                if let response = response as? HTTPURLResponse {
                    guard (200 ... 299) ~= response.statusCode else{
                        print("Status Code \(response.statusCode)")
                        print(response)
                        return
                    }
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch let error{
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

