import UIKit
import RxSwift
//import RxCocoa

protocol ViewModelType {
	associatedtype Input
	associatedtype Output
	
	var input: Input { get }
	var output: Output { get }
}
