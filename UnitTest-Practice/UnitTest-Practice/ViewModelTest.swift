import Foundation

import RxSwift
import RxTest
import Nimble
import RxNimble
import Quick

class ViewModelTest: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var dispoedBag: DisposeBag!
        
        describe("어떤 화면이 로드 되고") {
            var viewModel: ViewModel!
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                dispoedBag = DisposeBag()
                viewModel = ViewModel()
            }
            
            afterEach {
                scheduler = nil
                dispoedBag = nil
                viewModel = nil
            }
            
            context("타이틀이 입력 되면") {
                beforeEach {
                    scheduler.createColdObservable([
                        .next(5, "테스트 타이틀")
                    ])
                    .bind(to: viewModel.testInput.inputTitle)
                    .disposed(by: dispoedBag)
                }
                
                it("타이틀이 테스트 타이틀로 변경 된다.") {
                    expect(viewModel.testOutput.title.compactMap { $0 })
                        .events(scheduler: scheduler, disposeBag: dispoedBag)
                        .to(equal([
                            .next(0, ""),
                            .next(5, "테스트 타이틀")
                        ]))
                }
            }
            
            context("업 버튼이 3번 터치 되면") {
                beforeEach {
                    scheduler.createColdObservable([
                        .next(5, Void()),
                        .next(10, Void()),
                        .next(15, Void())
                    ])
                    .bind(to: viewModel.testInput.upButton)
                    .disposed(by: dispoedBag)
                }
                
                it("숫자가 3이 된다.") {
                    expect(viewModel.testOutput.number)
                        .events(scheduler: scheduler, disposeBag: dispoedBag)
                        .to(equal([
                            .next(0, 0),
                            .next(5, 1),
                            .next(10, 2),
                            .next(15, 3)
                        ]))
                }
            }
            
            context("다운 버튼이 2번 터치 되면") {
                beforeEach {
                    scheduler.createColdObservable([
                        .next(5, Void()),
                        .next(10, Void())
                    ])
                    .bind(to: viewModel.testInput.downButton)
                    .disposed(by: dispoedBag)
                }
                
                it("숫자가 -2이 된다.") {
                    expect(viewModel.testOutput.number)
                        .events(scheduler: scheduler, disposeBag: dispoedBag)
                        .to(equal([
                            .next(0, 0),
                            .next(5, -1),
                            .next(10, -2)
                        ]))
                }
                
                context("업 버튼이 1번 터치 되면") {
                    beforeEach {
                        scheduler.createColdObservable([
                            .next(15, Void())
                        ])
                        .bind(to: viewModel.testInput.upButton)
                        .disposed(by: dispoedBag)
                    }
                    
                    it("숫자가 -1이 된다.") {
                        expect(viewModel.testOutput.number)
                            .events(scheduler: scheduler, disposeBag: dispoedBag)
                            .to(equal([
                                .next(0, 0),
                                .next(5, -1),
                                .next(10, -2),
                                .next(15, -1)
                            ]))
                    }
                }
            }
        }
    }
}
