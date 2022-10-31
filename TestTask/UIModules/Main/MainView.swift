import UIKit

final class MainView: UITableView {
    let refreshControler = UIRefreshControl()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRefreshControler() {
        refreshControler.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.addSubview(refreshControler)
        refreshControler.layer.zPosition = -1
    }
}
