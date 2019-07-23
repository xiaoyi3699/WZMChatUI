//
//  WZMBaseInputView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMBaseInputView.h"
#import "WZMEmoticonManager.h"

@interface WZMBaseInputView ()<UITextViewDelegate,UITextFieldDelegate>

///初始y值
@property (nonatomic, assign) CGFloat startY;

///toolView的高度
@property (nonatomic, assign) CGFloat toolViewH;
///当前键盘的高度
@property (nonatomic, assign) CGFloat keyboardH;

///保存子类实现的输入框, 用来弹出系统键盘
@property (nonatomic, strong) UITextView *inputView1;
@property (nonatomic, strong) UITextField *inputView2;

///顶部toolView, 输入框就在这个view上
@property (nonatomic, strong) UIView *toolView;
///自定义键盘, 须子类使用方法传入
@property (nonatomic, strong) NSArray<UIView *> *keyboards;
///当前键盘类型
@property (nonatomic, assign) WZMKeyboardType type;
///当前键盘索引, -1为z系统键盘
@property (nonatomic, assign) NSInteger keyboardIndex;
///是否处于编辑状态, 自定义键盘模式也认定为编辑状态
@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation WZMBaseInputView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self prepareInit];
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self prepareInit];
        [self createViews];
    }
    return self;
}

- (void)prepareInit {
    self.startY = -1;
    self.editing = NO;
    self.keyboardIndex = -1;
    self.type = WZMKeyboardTypeIdle;
    self.keyboards = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardValueChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)createViews {
    self.backgroundColor = [UIColor whiteColor];
    self.toolView = [self toolViewOfInputView];
    self.toolViewH = self.toolView.bounds.size.height;
    for (UIView *view in self.toolView.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            self.inputView1 = (UITextView *)view;
            self.inputView1.delegate = self;
            break;
        }
        if ([view isKindOfClass:[UITextField class]]) {
            self.inputView2 = (UITextField *)view;
            self.inputView2.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.inputView2];
            break;
        }
    }
    [self addSubview:self.toolView];
    
    self.keyboards = [self keyboardsOfInputView];
    for (UIView *keyboard in self.keyboards) {
        keyboard.hidden = YES;
        [self addSubview:keyboard];
    }
    self.startY = [self startYOfInputView];
}

#pragma mark - 公开的方法
//使用时只需要调用这两个方法即可
- (void)chatBecomeFirstResponder {
    [self showSystemKeyboard];
}

- (void)chatResignFirstResponder {
    [self willResetConfig];
    [self dismissKeyboard];
}

#pragma mark - 监听键盘变化
- (void)keyboardValueChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    CGFloat duration = [dic[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect beginFrame = [dic[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect endFrame = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if (beginFrame.origin.y < endFrame.origin.y) {
        if (self.keyboardIndex == -1) {
            //系统键盘收回
            self.keyboardH = 0;
            [self minYWillChange:self.startY duration:duration dismissKeyboard:YES];
        }
        else {
            //自定义键盘弹出
            [self wzm_showKeyboardAtIndex:self.keyboardIndex duration:duration];
        }
    }
    else {
        //系统键盘弹出
        self.keyboardH = endFrame.size.height;
        self.keyboardIndex = -1;
        self.type = WZMKeyboardTypeSystem;
        CGFloat minY = endFrame.origin.y-self.toolView.bounds.size.height;
        [self minYWillChange:minY duration:duration dismissKeyboard:NO];
    }
}

- (void)minYWillChange:(CGFloat)minY duration:(CGFloat)duration dismissKeyboard:(BOOL)dismissKeyboard {
    if (dismissKeyboard) {
        self.keyboardIndex = -1;
        self.type = WZMKeyboardTypeIdle;
    }
    CGRect endFrame = self.frame;
    endFrame.origin.y = minY;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    }];
    [self willChangeFrameWithDuration:duration];
}

///子类设置toolView和keyboards
- (UIView *)toolViewOfInputView {
    return nil;
}

- (NSArray<UIView *> *)keyboardsOfInputView {
    return nil;
}

///视图的初始y值
- (CGFloat)startYOfInputView {
    if (self.startY == -1) {
        self.startY = [UIScreen mainScreen].bounds.size.height-self.toolViewH;
    }
    return self.startY;
}

///开始编辑
- (void)didBeginEditing {
    
}

///结束编辑
- (void)didEndEditing {
    
}

///输入框值改变
- (void)valueDidChange {
    
}

///是否允许开始编辑
- (BOOL)shouldBeginEditing {
    return YES;
}

///是否允许结束编辑
- (BOOL)shouldEndEditing {
    return YES;
}

///是否允许点击return键
- (BOOL)shouldReturn {
    return YES;
}

///是否允许编辑
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

///还原视图
- (void)willResetConfig {
    
}

///视图frameb改变
- (void)willChangeFrameWithDuration:(CGFloat)duration {
    
}

#pragma mark - 键盘事件处理
- (void)showSystemKeyboard {
    if (self.type != WZMKeyboardTypeSystem) {
        self.type = WZMKeyboardTypeSystem;
        if (self.inputView1) {
            [self.inputView1 becomeFirstResponder];
        }
        else if (self.inputView2) {
            [self.inputView2 becomeFirstResponder];
        }
    }
}

//判断是否直接弹出自定义键盘
- (void)showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration {
    if (index < 0 || index >= self.keyboards.count || self.keyboardIndex == index) return;
    if (self.type == WZMKeyboardTypeSystem) {
        //由系统键盘弹出自定义键盘
        //系统键盘收回, 在键盘监听事件中弹出自定义键盘
        self.keyboardIndex = index;
        [self endEditing:YES];
    }
    else {
        self.keyboardIndex = index;
        //直接弹出自定义键盘
        [self wzm_showKeyboardAtIndex:index duration:duration];
    }
}

- (void)dismissKeyboard {
    if (self.type == WZMKeyboardTypeIdle) return;
    if (self.type == WZMKeyboardTypeSystem) {
        [self endEditing:YES];
    }
    else {
        self.keyboardH = 0;
        [self minYWillChange:self.startY duration:0.25 dismissKeyboard:YES];
    }
    for (UIView *view in self.keyboards) {
        view.hidden = YES;
    }
}

//直接弹出自定义键盘
- (void)wzm_showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration {
    //直接弹出自定义键盘
    self.type = WZMKeyboardTypeOther;
    UIView *k;
    for (NSInteger i = 0; i < self.keyboards.count; i ++) {
        UIView *other = [self.keyboards objectAtIndex:i];
        if (i == index) {
            other.hidden = NO;
            k = other;
        }
        else {
            other.hidden = YES;
        }
    }
    if (k) {
        self.keyboardH = k.bounds.size.height;
        CGFloat minY = self.startY-self.keyboardH;
        [self minYWillChange:minY duration:duration dismissKeyboard:NO];
    }
}

//获取/设置输入框字符串
- (NSString *)text {
    if (self.inputView1) {
        return self.inputView1.text;
    }
    if (self.inputView2) {
        return self.inputView2.text;
    }
    return nil;
}

- (void)setText:(NSString *)text {
    if (self.inputView1) {
        self.inputView1.text = text;
    }
    if (self.inputView2) {
        self.inputView2.text = text;
    }
}

///输入框字符串处理
- (void)replaceSelectedTextWithText:(NSString *)text {
    if (self.inputView1) {
        [self.inputView1 replaceRange:self.inputView1.selectedTextRange withText:text];
    }
    if (self.inputView2) {
        [self.inputView2 replaceRange:self.inputView2.selectedTextRange withText:text];
    }
}

- (void)deleteSelectedText {
    if (self.inputView1) {
        if (self.inputView1.text.length > 0) {
            NSRange range = self.inputView1.selectedRange;
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            if (location == 0 && length == 0) return;
            if (length > 0) {
                [self.inputView1 deleteBackward];
            }
            else {
                NSString *subString = [self.inputView1.text substringToIndex:location];
                NSString *emoticon = [[WZMEmoticonManager manager] willDeleteEmoticon:subString];
                if ([[WZMEmoticonManager manager].chs containsObject:emoticon]) {
                    NSUInteger newLocation = location-emoticon.length;
                    self.inputView1.text = [self.inputView1.text stringByReplacingCharactersInRange:NSMakeRange(newLocation, emoticon.length) withString:@""];
                    self.inputView1.selectedRange = NSMakeRange(newLocation, 0);
                    [self valueDidChange];
                }
                else {
                    [self.inputView1 deleteBackward];
                }
            }
        }
    }
    if (self.inputView2) {
        if (self.inputView2.text.length > 0) {
            UITextRange *textRange = self.inputView2.selectedTextRange;
            UITextPosition *start = textRange.start;
            UITextPosition *end = textRange.end;
            
            UITextPosition *beginning = self.inputView2.beginningOfDocument;
            NSInteger location = [self.inputView2 offsetFromPosition:beginning toPosition:start];
            NSInteger length = [self.inputView2 offsetFromPosition:start toPosition:end];
            
            if (location == 0 && length == 0) return;
            if (length > 0) {
                [self.inputView2 deleteBackward];
            }
            else {
                NSString *subString = [self.inputView2.text substringToIndex:location];
                NSString *emoticon = [[WZMEmoticonManager manager] willDeleteEmoticon:subString];
                if ([[WZMEmoticonManager manager].chs containsObject:emoticon]) {
                    NSUInteger newLocation = location-emoticon.length;
                    self.inputView2.text = [self.inputView2.text stringByReplacingCharactersInRange:NSMakeRange(newLocation, emoticon.length) withString:@""];
                    
                    UITextPosition *beginning = self.inputView2.beginningOfDocument;
                    UITextPosition *start = [self.inputView2 positionFromPosition:beginning offset:newLocation];
                    UITextPosition *end = [self.inputView2 positionFromPosition:start offset:length];
                    UITextRange *textRange = [self.inputView2 textRangeFromPosition:start toPosition:end];
                    
                    self.inputView2.selectedTextRange = textRange;
                    [self valueDidChange];
                }
                else {
                    [self.inputView2 deleteBackward];
                }
            }
        }
    }
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        CGRect frame = self.frame;
        frame.origin.y = self.startY;
        self.frame = frame;
    }
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editing = YES;
    [self didBeginEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editing = NO;
    [self didEndEditing];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (![textField isKindOfClass:[UITextField class]]) return;
    [self valueDidChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [self shouldBeginEditing];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return [self shouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self shouldReturn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        NSString *language = textField.textInputMode.primaryLanguage;
        if ([language isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textField markedTextRange];
            if (selectedRange) {
                return YES;
            }
        }
        [self deleteSelectedText];
        return NO;
    }
    return [self shouldChangeTextInRange:range replacementText:string];
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.editing = YES;
    [self didBeginEditing];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.editing = NO;
    [self didEndEditing];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self valueDidChange];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return [self shouldBeginEditing];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return [self shouldEndEditing];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        NSString *language = textView.textInputMode.primaryLanguage;
        if ([language isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            if (selectedRange) {
                return YES;
            }
        }
        [self deleteSelectedText];
        return NO;
    }
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"]) {
        return [self shouldReturn];
    }
    return [self shouldChangeTextInRange:range replacementText:text];
}

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
