# kk_refresh

### Requirements
- ios8.0+
- swift3.0+

### Installation

```
pod 'kk_refresh'
```

### Usage

```
tableView.kk_header = RefreshView.kk_refresh(.gif(images), {
    code
})
tableView.kk_header.beginRefreshing()
```

- ***style:***
    
    支持5种风格的样式
    ```
    public enum RefreshStyle {
    
    case normal()              // 菊花指示器、title
    case gif([UIImage])        // 图片动画、title
    case gif_only([UIImage])   // 只有图片
    case text()                // 只有文字
    case indicator()           // 只有菊花指示器
    ```
    
    使用方式：可参见创建控件的方法，在创建控件的方法时的第一个参数就是传入指定的样式，如下：
    
    ```
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - style: 刷新控件的样式、风格
    ///   - complete: 刷新完成后的回调
    /// - Returns: 返回一个实例化对象
    
    public class func kk_refresh(_ style: RefreshStyle, _ complete: @escaping CallBack) -> RefreshView {
        ····
    }
    ```


