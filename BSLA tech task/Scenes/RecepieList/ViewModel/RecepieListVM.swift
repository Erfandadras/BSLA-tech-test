//
//  RecepieListVM.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import Combine

final class RecepieListVM: ObservableObject {
    // MARK: - dependencies
    private let dataSource: RecepieDataSourceRepo
    
    // MARK: - properties
    @Published var data = [UIRecepieItemModel]()
    @Published var error: Error?
    @Published var loading = true
    @Published var searching = false
    
    private var bag = Set<AnyCancellable>()
    
    // MARK: - init
    init(dataSource: RecepieDataSourceRepo) {
        self.dataSource = dataSource
        self._error = .init(initialValue: nil)
    }
}

// MARK: - logics
extension RecepieListVM {
    func getData() {
        loading = true
        dataSource.loadAllData { [weak self] result in
            guard let self = self else { return }
            self.loading = false
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error):
                //TODO: - handle error
                Logger.log(.error, error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        getData()
    }
    
    func filterData(with keyword: String) {
        let data = dataSource.filterData(with: keyword)
        if data.isEmpty {
            search(with: keyword)
        } else {
            self.data = data
        }
    }
    
    func search(with keyword: String) {
        searching = true
        dataSource.search(with: keyword) { [weak self] result in
            guard let self = self else { return }
            self.searching = false
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error):
                //TODO: - handle error
                Logger.log(.error, error.localizedDescription)
            }
        }
    }
    
    func bindData() {
        $error.sink { error in
            Logger.log(.error, error)
        }.store(in: &bag)
    }
}
