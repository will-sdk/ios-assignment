
import UIKit
import RxSwift
import SnapKit

class CitySearchViewController: UIViewController {
    
    var viewModel: CitySearchViewModel!
    
    let disposBag = DisposeBag()
    let tableview = UITableView()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindElements()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        // Register the cell class or nib with the table view
        tableview.register(CitySearchTableViewCell.self, forCellReuseIdentifier: CitySearchTableViewCell.reuseID)
        
        // Add search bar to the top of the view
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        // Add table view to the bottom of the view
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func bindElements() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = CitySearchViewModel.Input(trigger: viewWillAppear, selection: tableview.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.cities.drive(tableview.rx.items(cellIdentifier: CitySearchTableViewCell.reuseID, cellType: CitySearchTableViewCell.self)) { index, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposBag)
        
        output.selectedPost
            .drive()
            .disposed(by: disposBag)
    }
}
