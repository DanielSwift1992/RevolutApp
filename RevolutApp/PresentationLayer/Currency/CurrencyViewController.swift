import UIKit

final class CurrencyViewController: UIViewController {

    var handler: CurrencyEventHandler!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    private(set) var items: [Rate] = .init()
    private var cellHeight: CGFloat = 70
    private var isScrollAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.didLoad()
        handler.setupUpdater(interval: 1)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.apply {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CurrencyCell.self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollAnimating == false {
            handler.didScroll()
        } else if scrollView.contentOffset.y == 0 {
            isScrollAnimating = false
        }
    }
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handler.didSelectItem(at: indexPath.row)
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(for: indexPath)
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    private func configureCell(cell: CurrencyCell, index: Int) {
        let rate = items[index]
        cell.configure(item: rate, delegate: handler)
    }
}

extension CurrencyViewController: CurrencyViewBehavior {
    func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        guard activityIndicator.isHidden == false else { return }
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func set(rates: [Rate]) {
        items = rates
        tableView.reloadData()
    }
    
    func batchUpdate(remove: [IndexPath], insert: [IndexPath], items: [Rate]) {
        guard remove.isEmpty == false || insert.isEmpty == false else { return }
        self.items = items
        tableView.beginUpdates()
        tableView.insertRows(at: insert, with: .none)
        tableView.deleteRows(at: remove, with: .none)
        tableView.endUpdates()
    }
    
    func changePosition(from: Int, to: Int) {
        let item = items.remove(at: from)
        items.insert(item, at: to)
    }
    
    func moveToTop(row: IndexPath) {
        if tableView.contentOffset.y > 0 { isScrollAnimating = true }
        let topPath = IndexPath(row: 0, section: 0)
        tableView.moveRow(at: row, to: topPath)
        tableView.scrollToRow(at: topPath, at: .top, animated: true)
    }
    
    func finishEditing() {
        tableView.endEditing(true)
    }
}

