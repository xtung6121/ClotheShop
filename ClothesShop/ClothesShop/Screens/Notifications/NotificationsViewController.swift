import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class NotificationsViewController: BaseViewController<NotificationsViewModelType>, UIScrollViewDelegate {
    
    // MARK: - Types
    
    typealias NotificationSectionModel = SectionModel<String, NotificationItem>
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    
    override func setupUI() {
        super.setupUI()
        configureNavigation()
        configureTableView()
        configureLoadingIndicator()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindSections()
        bindLoading()
        bindError()
        triggerInitialLoad()
    }
}

extension NotificationsViewController {
    
    func configureNavigation() {
        title = "Notifications"
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "NotificationCell")
        
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func configureLoadingIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension NotificationsViewController {
    
    func bindSections() {
        let dataSource = makeDataSource()
        
        viewModel.outputs.sections
            .map(mapToSectionModels)
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindLoading() {
        viewModel.outputs.isLoading
            .drive(onNext: { [weak self] in
                $0 ? self?.activityIndicator.startAnimating()
                   : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    func bindError() {
        viewModel.outputs.error
            .emit(onNext: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func triggerInitialLoad() {
        viewModel.inputs.loadTrigger.onNext(())
    }
}

extension NotificationsViewController {
    
    func mapToSectionModels(_ apiSections: [NotificationSection]) -> [NotificationSectionModel] {
        apiSections.map {
            NotificationSectionModel(model: $0.sectionDate,
                                     items: $0.items)
        }
    }
}

extension NotificationsViewController {
    
    func makeDataSource() -> RxTableViewSectionedReloadDataSource<NotificationSectionModel> {
        
        RxTableViewSectionedReloadDataSource<NotificationSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NotificationCell",
                    for: indexPath
                )
                
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                content.textProperties.font = .boldSystemFont(ofSize: 16)
                content.secondaryText = item.description
                content.secondaryTextProperties.color = .secondaryLabel
                
                cell.contentConfiguration = content
                cell.selectionStyle = .none
                
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }
        )
    }
}
