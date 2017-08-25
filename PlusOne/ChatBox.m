//
//  ChatBox.m
//  buyer
//
//  Created by H.M.L on 2017/5/15.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ChatBox.h"
#import "AppDelegate.h"
#import "ServerCommunicator.h"
#import "ChattingView.h"

@interface ChatBox ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ChattingView *chattingView;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatConstrain;

@end

@implementation ChatBox
{
    ServerCommunicator *comm;
    NSMutableArray *getMessage;
    CGPoint bottomOffset;
    NSDictionary *parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if(self.getChatManager[@"receiver"])
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@",self.getChatManager[@"receiver"]];
    }
    else
    {
        self.navigationItem.title = self.receiver;
    }
    
    comm = [ServerCommunicator new];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    
    [self.chattingView addGestureRecognizer:tap];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRefreshJob) name:@"DID_RECEIVE_NOTIFICATION" object:nil];
    
    if(self.getChatManager[@"sender"])
    {
        parameters = @{@"sender":[NSString stringWithFormat:@"%@",self.getChatManager[@"sender"]],
                                     @"receiver":[NSString stringWithFormat:@"%@",self.getChatManager[@"receiver"]]};
    }
    else
    {
        parameters = @{@"sender":self.sender,
                       @"receiver":self.receiver};
    }
    
    getMessage = [NSMutableArray new];
    [comm doPostWithURLString:CHATMESSAGE_SELECT_URL
                   parameters:parameters
                         data:nil
                   completion:^(NSError *error, id result) {
                       getMessage = result;
                       for(int i = 0 ; i < getMessage.count ; i++)
                       {
                           {
                               [self addChatItemWithSender:[NSString stringWithFormat:@"%@",getMessage[i][@"sender"]]
                                                     image:nil
                                                   message:[NSString stringWithFormat:@"%@",getMessage[i][@"message"]]];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(),^{
                           [self.chattingView refreshAllItems];
                       });
                   }];
    
    //self.sendTextField.delegate = self;
    //向 NotificationCenter 申請註冊，在 UIKeyboardDidShowNotification 時，
    //會呼叫 keyboardDidShow (自訂的) 這個 selector。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    //向 NotificationCenter 申請註冊，在 UIKeyboardWillHideNotification 時，
    //會呼叫 keyboardWillHide (自訂的) 這個 selector。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) addChatItemWithSender:(NSString*)sender
                         image:(UIImage*)image
                       message:(NSString*)message {
    ChattingItem *item = [ChattingItem new];
    
    item.text = message;
    item.image = image;
    
    if(self.getChatManager[@"sender"])
    {
        if([sender isEqualToString:[NSString stringWithFormat:@"%@",self.getChatManager[@"sender"]]])
        {
            item.type = ChattingItemTypeFromMe;
        }
        else
        {
            item.type = ChattingItemTypeFromOthers;
        }
    }
    else
    {
        if([sender isEqualToString:self.sender])
        {
            item.type = ChattingItemTypeFromMe;
        }
        else
        {
            item.type = ChattingItemTypeFromOthers;
        }
    }
    
    [_chattingView addChattingItem:item];
}

- (IBAction)sendMessageBtn:(id)sender
{
    if(self.sendTextField.text.length == 0) {
        return;
    }
    
    if(self.getChatManager[@"sender"])
    {
        // Send Text with comm
        [comm sendTextMessage:[NSString stringWithFormat:@"%@",self.getChatManager[@"sender"]]
                      message:self.sendTextField.text
                     receiver:[NSString stringWithFormat:@"%@",self.getChatManager[@"receiver"]] completion:nil];
    }
    else
    {
        // Send Text with comm
        [comm sendTextMessage:self.sender
                      message:self.sendTextField.text
                     receiver:self.receiver
                   completion:nil];
    }
    
    
    ChattingItem *item = [ChattingItem new];
    
    item.text = self.sendTextField.text;
    
    item.type = ChattingItemTypeFromMe;
    [_chattingView addChattingItem:item];
}
/*
-(void)doRefreshJob
{
    NSLog(@"hiiihihihihifsdhfsdf");
    NSDictionary *parameters = @{@"sender":[NSString stringWithFormat:@"%@",self.getChatManager[@"sender"]],
                                 @"receiver":[NSString stringWithFormat:@"%@",self.getChatManager[@"receiver"]]};
    [comm doPostWithURLString:CHATMESSAGE_SELECT_URL
                   parameters:parameters
                         data:nil
                   completion:^(NSError *error, id result) {
                       getMessage = result;
                       for(int i = 0 ; i < getMessage.count ; i++)
                       {
                           {
                               [self addChatItemWithSender:[NSString stringWithFormat:@"%@",getMessage[i][@"sender"]]
                                                     image:nil
                                                   message:[NSString stringWithFormat:@"%@",getMessage[i][@"message"]]];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(),^{
                           [self.chattingView refreshAllItems];
                       });
                   }];
    NSLog(@"hiiihihihihifsdhfsdf");
}*/

-(void) keyboardDidShow: (NSNotification *) notification
{
    NSLog(@"didshow");
    //取得鍵盤高度
    //NSValue * value = [[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey];
    //CGFloat keyboardHeight = [value CGRectValue].size.height;
    
    
        //以動畫的方式，將 View 的 Y軸 往上移一個鍵盤高
    [UITextField animateWithDuration:0.3f animations:^
     {
         self.chatConstrain.constant = 272;
         
         
         /*
         CGRect frameTXF = self.sendTextField.frame;
         
         frameTXF.origin.y -= keyboardHeight;
         self.sendTextField.frame = frameTXF;
         
         CGRect frameBTN = self.sendBtn.frame;
         frameBTN.origin.y -= keyboardHeight;
         self.sendBtn.frame = frameBTN;
         
         CGRect frameSCV = self.chattingView.frame;
         frameSCV.origin.y -= keyboardHeight;
         self.chattingView.frame = frameSCV;
         self.chattingView.contentInset = UIEdgeInsetsMake(keyboardHeight, 0, 0, 0);
          */

     }];
}

-(void) keyboardWillHide: (NSNotification *) notification
{
    //NSLog(@"willhide");
    //NSValue * value = [[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
   // CGFloat keyboardHeight = [value CGRectValue].size.height;
    
    [UITextField animateWithDuration:0.3f animations:^
     {
         self.chatConstrain.constant = 0;

     }];
    
    /*
    [UITextField animateWithDuration:0.3f animations:^
     {
         CGRect frameTXF = self.sendTextField.frame;
         frameTXF.origin.y += keyboardHeight;
         self.sendTextField.frame = frameTXF;
     }];
    [UIButton animateWithDuration:0.3f animations:^
     {
         
         CGRect frameBTN = self.sendBtn.frame;
         frameBTN.origin.y += keyboardHeight;
         self.sendBtn.frame = frameBTN;
     }];
    [UIScrollView animateWithDuration:0.3f animations:^
     {
         
         CGRect frameSCV = self.chattingView.frame;
         frameSCV.origin.y += keyboardHeight;
         self.chattingView.frame = frameSCV;
         self.chattingView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
     }];
     */
}

//隱藏TabBar

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
 
//隱藏鍵盤function
- (void) cancelKeyboard {
    
    [self.sendTextField resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //只要有向 Notification Center 申請註冊，要記得 remove 掉
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
