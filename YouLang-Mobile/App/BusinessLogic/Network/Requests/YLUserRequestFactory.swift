//
//  YLUserRequestFactory.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 24/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

protocol YLUserRequestFactory {
    func getInfo(accessToken: String, completionHandler: @escaping (DataResponse<YLUserModel>) -> Void);
}
