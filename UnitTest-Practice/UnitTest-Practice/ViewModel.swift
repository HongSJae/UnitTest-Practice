import Foundation

import RxSwift
import RxCocoa

struct ViewModel {
    struct Input {
        var inputTitle: AnyObserver<String?>
        var upButton: AnyObserver<Void?>
        var downButton: AnyObserver<Void?>
    }

    struct Output {
        var title: Driver<String>
        var number: Driver<Int>
    }

    let testInput: Input
    let testOutput: Output
    
    private var disposedBag: DisposeBag = DisposeBag()
    
    //MARK: - Input
    private let _inputTitle = BehaviorSubject<String?>(value: nil)
    private let _upButton = BehaviorSubject<Void?>(value: nil)
    private let _downButton = BehaviorSubject<Void?>(value: nil)
    
    //MARK: - Output
    private let _title = BehaviorSubject<String>(value: "")
    private let _number = BehaviorRelay<Int>(value: 0)
    
    init() {
        testInput = Input(
            inputTitle: _inputTitle.asObserver(),
            upButton: _upButton.asObserver(),
            downButton: _downButton.asObserver()
        )
        
        testOutput = Output(
            title: _title.asDriver(onErrorJustReturn: ""),
            number: _number.asDriver(onErrorJustReturn: 0)
        )
        
        self._bindInputTitle()
        self._bindUpButton()
        self._bindDownButton()
    }
    
    private func _bindInputTitle() {
        self._inputTitle
            .compactMap { $0 }
            .bind(to: _title)
            .disposed(by: disposedBag)
    }
    
    private func _bindUpButton() {
        self._upButton
            .compactMap { $0 }
            .map { _ -> Int in
                let number = _number.value
                return number + 1
            }
            .bind(to: _number)
            .disposed(by: disposedBag)
    }
    
    private func _bindDownButton() {
        self._downButton
            .compactMap { $0 }
            .map { _ -> Int in
                let number = _number.value
                return number - 1
            }
            .bind(to: _number)
            .disposed(by: disposedBag)
    }
}
