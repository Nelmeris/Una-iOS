//
//  StudyViewPresenter.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 06.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation
import Keychain

protocol StudyView: class {
    func setCources(cources: [YLCourceModel], viewModels: [CourceViewModel])
}

protocol StudyViewPresenter {
    init(view: StudyView)
    func showCources()
}


class StudyPresenter : StudyViewPresenter {
    
    unowned let view: StudyView
    private let viewModelFactory = CourceViewModelFactory()
    
    required init(view: StudyView) {
        self.view = view
    }
    
    func showCources() {
        loadData { cources in
            let viewModels = self.viewModelFactory.construct(from: cources)
            self.view.setCources(cources: cources, viewModels: viewModels)
        }
    }
    
    private func loadData(completion: @escaping ([YLCourceModel]) -> ()) {
        guard let accessToken = Keychain.load("access_token") else { return }
        YLService.shared.getCources(accessToken: accessToken) { (response) in
            switch response.result {
            case .success(let cources):
                completion(cources)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
}
