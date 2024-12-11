//
//  OverlayView.swift
//  WeiHong
//
//  Created by developeng on 2024/12/10.
//

import Foundation
import UIKit

public  var ReportAlertMaxH: CGFloat = ScreenHeight * 0.7

class OverlayTestView: UIView {
    
    var didSelectBlock:(()->Void)?
    
    public var cellH: CGFloat = 44.auto()
    private var selectedIndex:Int = 0
    
    public var viewMaxHeight: CGFloat = ReportAlertMaxH {
        didSet{
            if viewMaxHeight > ReportAlertMaxH {
                viewMaxHeight = ReportAlertMaxH
            }
        }
    }
    
    var itemArray: Array<WHReportEnumItemModel>? {
        didSet {
            guard let arr = itemArray else {
                return
            }
            self.selectedIndex = 0
            arr.forEach({ model in
                model.isSel = false
            })
            arr.first?.isSel = true
            self.updateUiShow(state: 1)
            self.updateAlertUi(leftCount: arr.count, rightCount: arr.first?.subpageData?.count ?? 0)
        }
    }
            
    lazy var leftView:UITableView = {
        let tableView:UITableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.backGroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        tableView.register(WHReportEnumLeftCell.self, forCellReuseIdentifier: "WHReportEnumLeftCell")
        return tableView
    }()
    
    lazy var rightView:UITableView = {
        let tableView:UITableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        tableView.register(WHReportEnumRightCell.self, forCellReuseIdentifier: "WHReportEnumRightCell")
        return tableView
    }()
        
    // MARK: - circle life
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSubInit()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSubInit(){
        self.addSubview(self.leftView)
        self.addSubview(self.rightView)
    }
    
    func updateAlertUi(leftCount:Int = 0,rightCount:Int = 0) {
        // 切换左边时，右边个数比左边多时，可能需要更新弹窗高度
        let leftH:CGFloat = CGFloat(leftCount) * cellH
        let rightH:CGFloat = CGFloat(rightCount) * cellH
        let maxH = (leftCount > rightCount) ? leftH : rightH
        self.viewMaxHeight = maxH
        self.updateUiShow(state: 1)
        self.leftView.reloadData()
        self.rightView.reloadData()
    }
    
    func updateUiShow(state: Int) {
        self.leftView.frame = CGRect(x: 0, y: 0, width: 100, height: self.viewMaxHeight)
        self.rightView.frame = CGRect(x: 100, y: 0, width: ScreenWidth - 100, height: self.viewMaxHeight)
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.viewMaxHeight)
    }
    
    func updateUiHide() {
        self.leftView.frame = CGRect(x: 0, y: 0, width: 100, height:0)
        self.rightView.frame = CGRect(x: 100, y: 0, width: ScreenWidth - 100, height: 0)
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
    }
    
    
}
extension OverlayTestView: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == self.leftView {
            return self.itemArray?.count ?? 0
        }
        if ((self.itemArray?.count ?? 0) - 1) >= self.selectedIndex {
            return self.itemArray?[self.selectedIndex].subpageData?.count ?? 0
        }
        return 0    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.leftView {
            let cell:WHReportEnumLeftCell = tableView.dequeueReusableCell(withIdentifier: "WHReportEnumLeftCell", for: indexPath) as! WHReportEnumLeftCell
            let model = self.itemArray?[indexPath.row]
            cell.model = model
            return cell
        }
        let cell:WHReportEnumRightCell = tableView.dequeueReusableCell(withIdentifier: "WHReportEnumRightCell", for: indexPath) as! WHReportEnumRightCell
        let model = self.itemArray?[self.selectedIndex].subpageData?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftView {
            self.selectedIndex = indexPath.row
            self.itemArray?.forEach({ model in
                model.isSel = false
            })
            let selModel = self.itemArray?[indexPath.row]
            selModel?.isSel = true
            self.updateAlertUi(leftCount: self.itemArray?.count ?? 0, rightCount: selModel?.subpageData?.count ?? 0)
        } else {
            if self.didSelectBlock != nil {
                self.didSelectBlock!()
            }
        }
    }
}



class WHReportEnumLeftCell: UITableViewCell {
    
    var tipLab:UILabel!
    var nameLab:UILabel!
    var lineLab:UILabel!
    var model: WHReportEnumItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.nameLab.text = model.name
            if model.isSel {
                self.backgroundColor = .white
                self.tipLab.isHidden = false
                self.nameLab.textColor = .hex(0x333333)
                self.nameLab.font = .boldSystemFont(ofSize: 14.auto())
             
            } else {
                self.backgroundColor = .backGroundColor
                self.tipLab.isHidden = true
                self.nameLab.textColor = .hex(0x666666)
                self.nameLab.font = .systemFont(ofSize: 14.auto())
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.tipLab = {
            let label = UILabel()
            label.backgroundColor = .themeColor
            return label
        }()
        self.contentView.addSubview(self.tipLab)
        
        self.nameLab = {
            let label = UILabel()
            label.textColor = .hex(0x333333)
            label.font = .systemFont(ofSize: 14.auto())
            label.numberOfLines = 2
            return label
        }()
        self.contentView.addSubview(self.nameLab)
        
        self.lineLab = {
            let label = UILabel()
            label.backgroundColor = .backGroundColor
            return label
        }()
        self.contentView.addSubview(self.lineLab)
        
        self.nameLab.snp.makeConstraints { make in
            make.left.equalTo(self.tipLab.snp.left).offset(8.auto())
            make.right.equalToSuperview().offset(-5.auto())
            make.centerY.equalToSuperview()
        }
        
        self.tipLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.auto())
            make.width.equalTo(2.auto())
            make.height.equalTo(17.auto())
            make.centerY.equalToSuperview()
        }
        
        self.lineLab.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
}



class WHReportEnumRightCell: UITableViewCell {
    
    var nameLab:UILabel!
    var lineLab:UILabel!
    var model: WHReportEnumItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.nameLab.text = model.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .white
        
        self.nameLab = {
            let label:UILabel = UILabel()
            label.textColor = .hex(0x333333)
            label.font = .systemFont(ofSize: 15.auto())
            label.numberOfLines = 2
            return label
        }()
        self.contentView.addSubview(self.nameLab)
        
        self.lineLab = {
            let label = UILabel()
            label.backgroundColor = .hex(0xEEEEEE)
            return label
        }()
        self.contentView.addSubview(self.lineLab)

        self.nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8.auto())
            make.right.equalToSuperview().offset(-5.auto())
            make.centerY.equalToSuperview()
        }
        
        self.lineLab.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
