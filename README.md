# KSMultistageScrollViewHelper
处理scrollView嵌套、cell嵌套webView、自适应高度的webView

## [简书](https://www.jianshu.com/p/17ad0bc40c4f)

- **前言**
- **让Webview完全展开**
- **让WebView自适应**
- **让装载WebView的Cell，自适应大小**
- **如何让一个装载着WebView的Cell，能够上拉加载**
- **如果你是伸手党?**

***
### 前言
> 很久不写东西了，新工作每天忙的不行。这个东西也是做技术调研，感觉还不错顺手搞出的副产品。

列出了几种html嵌套在原生页面内的方式。如果正巧你也需要，可以选一个用用。

***
### 让Webview完全展开
>最简便的方式，在HTML高度发生变化之后，令tableView进行reload操作。使用HTML高度设置cell高度。

网上有很多、有需要自己搜一下
![](https://upload-images.jianshu.io/upload_images/1552225-870f9189a54b8b61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

需要注意webView加载完成后，高度很可能并未确定，比如图片加载等操作有机会继续修改html高度。
所以通过KVO监听是最稳妥的。

***
### 让WebView自适应
>让WebView具有UILabel的性质，进而撑开cell。达到自适应的目的

![](https://upload-images.jianshu.io/upload_images/1552225-f14413bd71bf6381.gif?imageMogr2/auto-orient/strip)


在上面提到的kvo监听方法中,调用`invalidateIntrinsicContentSize`
```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.loading) {
        return;
    }
    CGFloat height = self.webView.scrollView.contentSize.height;
    if (self.HtmlHeight != height) {
        self.HtmlHeight = height;
        
        //这里加了一个延时，因为最开始`height`会频繁刷新。最后才稳定成最终值
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.HtmlHeight == height) {
                [self invalidateIntrinsicContentSize];
            }
        });
    }
}
```

然后在`intrinsicContentSize`返回控件的内容高度
```
- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, self.HtmlHeight);
}
```

题外话`intrinsicContentSize`是个好东西，你可以用他，实现一个适应的textView，textField等一切你有办法确定大小的东西。


***
### 让装载WebView的Cell，自适应大小
> 就像使用UILabel一样添加约束

![](https://upload-images.jianshu.io/upload_images/1552225-939f126683cac5f3.gif?imageMogr2/auto-orient/strip)



```
- (void)setWebViewEdgeInsets:(UIEdgeInsets)webViewEdgeInsets {
    _webViewEdgeInsets = webViewEdgeInsets;
    [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(webViewEdgeInsets);
    }];
}
```

高度确定之后，让tableViewReload
```
//Cell
#pragma mark - KSAdaptiveHtmlViewDelegate
- (void)htmlViewDidFinishLoad:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(htmlCellDidFinishLoad:cell:)]) {
        self.HtmlHeight = height;
        [self.delegate htmlCellDidFinishLoad:height cell:self];
    }
}

//ViewController
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
    
}

#pragma mark KSAdaptiveHTMLCellDelegate
- (void)htmlCellDidFinishLoad:(CGFloat)height cell:(KSAdaptiveHTMLCell *)cell{
    NSLog(@"htmlCellDidFinishLoad");
    [self.tableView reloadData];
}

```

***
### 如何让一个装载着WebView的Cell，能够上拉加载
> 如果把Cell的高度撑开，与WebView相同，那么这个WebView将失去上拉加载的功能。
我这里的处理是将WebView确定在一定的高度(比如和tableView一样大)，然后另其与tableView联动滑动。

![](https://upload-images.jianshu.io/upload_images/1552225-7b9fa23ae5f6ca05.gif?imageMogr2/auto-orient/strip)





联动的处理上，参考了[HGPersonalCenterExtend](https://github.com/ArchLL/HGPersonalCenterExtend/blob/master/README.md)。抛开cell的干扰，其实就是scrollView与scrollView的嵌套。


本质上，就是两个scrollView本身都在响应滑动事件。当一个scrollView不应该滑动时，让其锁定在某个位置。
```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat lockOffset = self.baseScrollSubView.frame.origin.y; //baseScrollView将要被锁定的偏移量
    if (self.baseScrollView == scrollView) {
        if (self.baseScrollView.contentOffset.y >= lockOffset) { //baseScrollView自己超过了锁定距离
            self.baseScrollView.contentOffset = CGPointMake(0, lockOffset);
            self.baseViewScroll = NO;
        }else{
            if (!self.baseViewScrolling  && self.subScrollView.contentOffset.y > 0) {//subScrollView正在滚动
                self.baseScrollView.contentOffset = CGPointMake(0, lockOffset);
            }
        }
        self.baseScrollView.showsVerticalScrollIndicator = self.baseViewScrolling?YES:NO;
    }
    if (self.subScrollView == scrollView) {
        if (self.baseScrollView.contentOffset.y != lockOffset) { //如果baseScrollView处在锁定位置，都要去滚动父ScrollView
            self.baseViewScroll = YES;
        }
        if (self.baseViewScrolling) {
            self.subScrollView.contentOffset = CGPointZero;
        }
        if (self.subScrollView.contentOffset.y <= 0) { //subScrollView到顶后屏蔽下拉动作
            self.subScrollView.contentOffset = CGPointZero;
            self.baseViewScroll = YES;
        }
        self.subScrollView.showsVerticalScrollIndicator = self.baseViewScrolling?NO:YES;
    }
}
```

如此这般，你就可以让webView在不充满的前提下，与tableView联动了。

***
### 如果你是伸手党?
> 是的，之所以前面写的很简略。是因为有demo~

顺手，我把联动的逻辑抽了出来，你只要把两个scrollView丢进去，他们就可以自己联动的滑起来。
```

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrollHelper];
}

- (KSMultistageScrollViewHelper *)scrollHelper {
    if (!_scrollHelper) {
        _scrollHelper = [[KSMultistageScrollViewHelper alloc]initWithBaseScrollView:self.firstScrollView subScrollView:self.secondScrollView];
    }
    return _scrollHelper;
}
```




