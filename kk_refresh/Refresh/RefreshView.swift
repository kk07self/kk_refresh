//
//  RefreshView.swift
//  Refresh
//
//  Created by 陈康 on 2017/3/24.
//  Copyright © 2017年 陈康. All rights reserved.
//

import UIKit

fileprivate let kwidth = UIScreen.main.bounds.size.width
fileprivate let kheight = UIScreen.main.bounds.size.height
fileprivate let kObserverKey = "contentOffset"
private let kImageWidth: CGFloat = 44


///////////////////////////////////////////////////////////////////////////////////////////////
/// 控件刷新样式
// MARK: - 控件刷新样式 ***********************************
public enum RefreshStyle {
    
    case normal()              // 菊花指示器、title
    case gif([UIImage])        // 图片动画、title
    case gif_only([UIImage])   // 只有图片
    case text()                // 只有文字
    case indicator()           // 只有菊花指示器
    
    var images: [UIImage]? {
        switch self {
        case .gif(let images), .gif_only(let images):
            return images
        default:
            return nil
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////
/// 显示状态
// MARK: - 刷新、加载状态 **********************************
public enum Status {
    case none
    case header_normal
    case header_wait
    case refresh
    case footer_normal
    case footer_wait
    case footer_noData
    
    var string: String {
        switch self {
        case .header_normal:
            return NSLocalizedString("下拉刷新", comment: "下拉刷新")
        case .header_wait:
            return NSLocalizedString("释放更新", comment: "释放更新")
        case .refresh:
            return NSLocalizedString("加载中···", comment: "加载中···")
        case .footer_noData:
            return NSLocalizedString("已没有更多数据", comment: "已没有更多数据")
        case .footer_wait:
            return NSLocalizedString("释放加载", comment: "释放加载")
        case .footer_normal:
            return NSLocalizedString("上拉加载", comment: "上拉加载")
        default:
            return ""
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
/// 刷新控件
// MARK: - 刷新控件 ****************************************核心
public class RefreshView : UIView {
    
    public enum RefreshType {
        case header
        case footer
        case none
    }
    
    // scrollView的原便宜位置
    fileprivate var superViewOriginOffsetY: CGFloat = 0
    
    // 子控件
    open var indicator: UIActivityIndicatorView!
    open var imageView: UIImageView!
    open var title: UILabel!
    
    // 控件约束---不同的样式需要修改这个属性进行调整
    fileprivate var imageRightConstraint: NSLayoutConstraint!
    
    // 父控件
    fileprivate weak var scrollView: UIScrollView?
    
    public typealias CallBack = () -> Void
    
    // 保存刷新时执行的操作
    public var callBack: CallBack?
    
    
    /// 刷新的状态
    fileprivate var style: RefreshStyle = .normal() {
        didSet {
            switch style {
            case .normal():
                imageView.isHidden = true
                
            case .gif(_):
                indicator.isHidden = true
                imageView.image = style.images?.first
                
            case .gif_only(_):
                imageView.image = style.images?.first
                indicator.isHidden = true
                title.isHidden = true
                title.text = ""
                imageRightConstraint.constant = kImageWidth * 0.5
                
            case .text():
                imageView.isHidden = true
                indicator.isHidden = true
                
            case .indicator():
                imageView.isHidden = true
                title.isHidden = true
                imageRightConstraint.constant = kImageWidth * 0.5
            }
        }
    }
    
    // 是否正在刷新
    var isRefreshing = false
    
    // 刷新的样式：头部还是底部
    public var refreshType: RefreshType = .none
    
    // 刷新控件显示的内容状态： 状态的改变会修改到刷新控件的样式，所以要进行调整
    public var status: Status = .none {
        didSet {
            
            title.text = status.string
            // 底部控件没有更多内容时
            if status == .footer_noData {
                indicator.isHidden = true
                imageView.isHidden = true
            } else {
                switch style {
                case .gif(_),.gif_only(_):
                    indicator.isHidden = true
                    imageView.isHidden = false
                case .indicator(), .normal():
                    indicator.isHidden = false
                    imageView.isHidden = true
                default:
                    indicator.isHidden = true
                    imageView.isHidden = true
                }
                
                switch style {
                case .gif_only(_),.indicator():
                    title.text = ""
                default:
                    title.text = status.string
                }
            }
        }
    }
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - style: 刷新控件的样式、风格
    ///   - complete: 刷新完成后的回调
    /// - Returns: 返回一个实例化对象
    
    public class func kk_refresh(_ style: RefreshStyle, _ complete: @escaping CallBack) -> RefreshView {
        let refresh = RefreshView()
        refresh.addSubViews()
        refresh.callBack = complete
        refresh.style = style
        return refresh
    }
    
    private func addSubViews() {
        // title
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        let title_centerX = NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let title_centerY = NSLayoutConstraint(item: title, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        // imageView
        imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image_centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let image_Right = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: title, attribute: .left, multiplier: 1, constant: -20)
        imageRightConstraint = image_Right
        let image_width = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kImageWidth)
        let image_height = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: kImageWidth)
        
        // indicator
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = false
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let in_top = NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1, constant: 0)
        let in_lef = NSLayoutConstraint(item: indicator, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1, constant: 0)
        let in_rig = NSLayoutConstraint(item: indicator, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 0)
        let in_bot = NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0)
        
        addConstraints([title_centerX,title_centerY,
                        image_centerY,image_Right,image_width,image_height,
                        in_top,in_lef,in_rig,in_bot])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // 给自己布局位置
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if refreshType == .footer {
            frame = CGRect(x: 0, y:(scrollView?.contentSize.height)!, width: kwidth, height: 44)
        }
        if refreshType == .header {
            frame = CGRect(x: 0, y: -64, width: kwidth, height: 64)
        }
    }
}



// MARK: - 开始、结束刷新方法
public extension RefreshView {
    
    
    /// 主动刷新方法——
    public func beginRefresh() {
        if refreshType == .header {
            scrollView?.setContentOffset(CGPoint(x:scrollView?.contentOffset.x ?? 0, y: (scrollView?.contentOffset.y ?? 0) - 65), animated: true)
        } else {
            beginRefreshing()
        }
    }
    
    /// 开始刷新控件
    fileprivate func beginRefreshing() {
        isRefreshing = true
        status = .refresh
        
        // 悬停
        var inset = scrollView?.contentInset
        if refreshType == .header {
            inset?.top += 64
        } else {
            inset?.bottom += 44
        }
        UIView.animate(withDuration: 0.25) { 
            (self.scrollView)?.contentInset = inset!
        }
        
        // 正在刷新的样式
        switch style {
        case .text():
            break
            
        case .normal(), .indicator():
            indicator.startAnimating()
            
        case .gif(_), .gif_only(_):
            imageView.animationDuration = 2.5
            imageView.animationImages = style.images
            imageView.startAnimating()
        }
        
        // 回到主线程回调
        self.callBack?()
    }
    
    /// 结束刷新控件
    public func stopRefreshing() {
        
        isRefreshing = false
        
        // 结束刷新的样式
        switch style {
        case .text():
            break
            
        case .normal(), .indicator():
            indicator.stopAnimating()
            
        case .gif(_), .gif_only(_):
            imageView.stopAnimating()
            imageView.image = style.images?.first
        }
        
        // 去除悬停
        var inset = scrollView?.contentInset
        if refreshType == .header {
            inset?.top -= 64
        } else {
            inset?.bottom -= 44
        }
        UIView.animate(withDuration: 0.25, animations: { 
            (self.scrollView)?.contentInset = inset!
        }) { (isComplete) in
            self.status = self.refreshType == .footer ? .footer_normal: .header_normal
        }
    }
}


// MARK: - 监听滚动位置

public extension RefreshView {
    
    
    /// 添加观察者
    ///
    /// - Parameter type: 是头部还是底部控件
    fileprivate func addObserver(_ type: RefreshType) {
        // 属性设置初始值
        self.refreshType = type
        self.status = type == .header ? .header_normal : .footer_normal
        scrollView = (superview as? UIScrollView)
        superViewOriginOffsetY = scrollView!.contentOffset.y
        scrollView?.addObserver(self, forKeyPath: kObserverKey, options: .new, context: nil)
    }
    
    /// 监听滚动范围
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == kObserverKey {
            
            // 正在刷新、隐藏、没有内容状态下 不进行处理
            if isRefreshing || isHidden || status == .footer_noData {
                return
            }
            
            if let point = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
                guard let scrollView = superview as? UIScrollView else {
                    return
                }
                
                // 正在拖拽时不进行刷新，拖拽结束后进行刷新
                if scrollView.isDragging {
                    if refreshType == .header {
                        status = point.y < superViewOriginOffsetY - 64 ? .header_wait : .header_normal
                    } else {
                        status = point.y >= scrollView.contentSize.height - scrollView.frame.size.height + 64 ? .footer_wait : .footer_normal
                    }
                    return
                }
                
                // 头部刷新控件的处理
                if refreshType == .header {
                    if scrollView.contentOffset.y < superViewOriginOffsetY - 64 && !isRefreshing {
                        self.beginRefreshing()
                    }
                } else {
                    
                    // 尾部加载控件的处理
                    
                    // 如果scrollView没有内容或者内容尺寸小于scrollView内容的时不进行操作
                    if scrollView.contentSize.height == 0 || scrollView.frame.size.height >= scrollView.contentSize.height {
                        return
                    }
                    
                    // 拖拽到一定位置是进行处理
                    if point.y > scrollView.contentSize.height - scrollView.frame.size.height + 64 && !isRefreshing {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
}


// MARK: - scrollView扩展属性
public extension UIScrollView {
    
    /// 扩展属性的键值对
    private struct AssociateKeys {
        static var kk_header = "kk_header"
        static var kk_footer = "kk_footer"
    }
    
    /// 头部控件
    public var kk_header: RefreshView {
        
        set(value) {
            self.addSubview(value)
            value.addObserver(.header)
            objc_setAssociatedObject(self, &AssociateKeys.kk_header, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.kk_header) as! RefreshView
        }
    }
    
    /// 底部控件
    public var kk_footer: RefreshView {
        
        set(value) {
            self.addSubview(value)
            value.addObserver(.footer)
            objc_setAssociatedObject(self, &AssociateKeys.kk_footer, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.kk_footer) as! RefreshView
        }
    }
    
    // 当刷新控件要移除scrollView时移除监听
    open override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if let subview = subview as? RefreshView {
            self.removeObserver(subview, forKeyPath: kObserverKey)
        }
    }
}
