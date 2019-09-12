import UIKit
import RxSwift
import RxCocoa

/// Every view interacting with a `SayHelloViewModel` instance can conform to this.
protocol SayHelloViewModelBindable {
	var disposeBag: DisposeBag? { get }
	func bind(to viewModel: SayHelloViewModel)
}

/// TableViewCells
final class TextFieldCell: UITableViewCell, SayHelloViewModelBindable {
	@IBOutlet weak var nameTextField: UITextField!
	var disposeBag: DisposeBag?
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		// Clean Rx subscriptions
		disposeBag = nil
	}
	
	func bind(to viewModel: SayHelloViewModel) {
		let bag = DisposeBag()
		nameTextField.rx
			.text
			.orEmpty
			.bind(to: viewModel.input.name)
			.disposed(by: bag)
		disposeBag = bag
	}
}

final class ButtonCell: UITableViewCell, SayHelloViewModelBindable {
	@IBOutlet weak var validateButton: UIButton!
	var disposeBag: DisposeBag?
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = nil
	}
	
	func bind(to viewModel: SayHelloViewModel) {
		let bag = DisposeBag()
		validateButton.rx
			.tap
			.bind(to: viewModel.input.validate)
			.disposed(by: bag)
		disposeBag = bag
	}
}

final class GreetingCell: UITableViewCell, SayHelloViewModelBindable {
	@IBOutlet weak var greetingLabel: UILabel!
	var disposeBag: DisposeBag?
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = nil
	}
	
	func bind(to viewModel: SayHelloViewModel) {
		let bag = DisposeBag()
		viewModel.output.greeting
			.drive(greetingLabel.rx.text)
			.disposed(by: bag)
		disposeBag = bag
	}
}

/// View
class TableViewController: UIViewController, UITableViewDataSource {
	static let cellIdentifiers = [
		"TextFieldCell",
		"ButtonCell",
		"GreetingCell"
	]
	
	@IBOutlet weak var tableView: UITableView!
	
	private let viewModel = SayHelloViewModel()
	private let bag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.alwaysBounceVertical = false
		tableView.dataSource = self
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return TableViewController.cellIdentifiers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.cellIdentifiers[indexPath.row])
		(cell as? SayHelloViewModelBindable)?.bind(to: viewModel)
		return cell!
	}
}
