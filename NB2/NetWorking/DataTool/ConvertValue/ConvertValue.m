//
//  ConvertValue.m
//  36cn
//
//  Created by shi on 13-12-12.
//  Copyright (c) 2013年 shi. All rights reserved.
//

#import "ConvertValue.h"

@implementation ConvertValue

#pragma mark - 判断为空
+ (BOOL)isNULL:(NSString*)string{
    if (((NSNull *)string == [NSNull null]||string == nil || string.length == 0 || [string isEqualToString:@""])) {
        return YES;
    }else{
        return NO;
    }
}
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font

{
    CGRect rect=CGRectMake(0, 0, SCREEN_WIDTH,[string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height);
    
    
    return rect.size;
}
//求只能输入整数或小数的正则表达式
+(BOOL) isValidateshuzi:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];

}
//  数字加逗号间隔的方法
+(NSString *)numWithSign:(NSString *)floatStr
{
    @try
    {
        if (floatStr.length < 3)
        {
            return floatStr;
        }
        NSString *numStr = floatStr;
        NSArray *array = [numStr componentsSeparatedByString:@"."];
        NSString *numInt = [array objectAtIndex:0];
        if (numInt.length <= 3)
        {
            return floatStr;
        }
        NSString *suffixStr = @"";
        if ([array count] > 1)
        {
            suffixStr = [NSString stringWithFormat:@".%@",[array objectAtIndex:1]];
        }
        
        NSMutableArray *numArr = [[NSMutableArray alloc] init];
        while (numInt.length > 3)
        {
            NSString *temp = [numInt substringFromIndex:numInt.length - 3];
            numInt = [numInt substringToIndex:numInt.length - 3];
            [numArr addObject:[NSString stringWithFormat:@",%@",temp]];//得到的倒序的数据
        }
        long count = [numArr count];
        for (int i = 0; i < count; i++)
        {
            numInt = [numInt stringByAppendingFormat:@"%@",[numArr objectAtIndex:(count -1 -i)]];
        }
        numStr = [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
        return numStr;
    }
    @catch (NSException *exception)
    {
        return floatStr;
    }
    @finally
    {}

}


//+(NSMutableAttributedString *)titleSign:(NSString *)descri
//{
//    NSMutableArray *tempWordsL = [[NSMutableArray alloc] init];
//    NSMutableArray *tempWordsR = [[NSMutableArray alloc] init];
//    NSMutableArray *tempWords = [[NSMutableArray alloc] init];
//    const char *tempStr = [descri cStringUsingEncoding:NSUTF8StringEncoding];
//    char *tempWord;
//    
//    //添加字串分割成单个元素存入可变数组
//    for (int i = 0; i < strlen(tempStr);) {
//        int len = 0;
//        if (tempStr[i] >= 0xFFFFFFFC) {
//            len = 6;
//        } else if (tempStr[i] >= 0xFFFFFFF8) {
//            len = 5;
//        } else if (tempStr[i] >= 0xFFFFFFF0) {
//            len = 4;
//        } else if (tempStr[i] >= 0xFFFFFFE0) {
//            len = 3;
//        } else if (tempStr[i] >= 0xFFFFFFC0) {
//            len = 2;
//        } else if (tempStr[i] >= 0x00) {
//            len = 1;
//        }
//        
//        tempWord = malloc(sizeof(char) * (len + 1));
//        for (int j = 0; j < len; j++) {
//            tempWord[j] = tempStr[j + i];
//        }
//        tempWord[len] = '\0';
//        i = i + len;
//        
//        NSString *oneWord = [NSString stringWithCString:tempWord encoding:NSUTF8StringEncoding];
//        free(tempWord);
//        [tempWords addObject:oneWord];
//    }    
//    [tempWordsL addObjectsFromArray:[self getNumFromString:tempWords :@"【"]];
//    [tempWordsR addObjectsFromArray:[self getNumFromString:tempWords :@"】"]];
//    
//    NSMutableAttributedString *strDescri = [[NSMutableAttributedString alloc] initWithString:[tempWords componentsJoinedByString:@""]];
//
//    for (int i=0; i<[tempWordsL count]; i++) {
//        [strDescri addAttribute:NSForegroundColorAttributeName value:kNarvigationBarBgColor range:NSMakeRange([[tempWordsL objectAtIndex:i] intValue] ,[[tempWordsR objectAtIndex:i] intValue]-[[tempWordsL objectAtIndex:i] intValue]+1)];
//        [strDescri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14] range:NSMakeRange([[tempWordsL objectAtIndex:i] intValue] ,[[tempWordsR objectAtIndex:i] intValue]-[[tempWordsL objectAtIndex:i] intValue]+1)];
//    }
//    
//    return strDescri;
//}

+(NSMutableArray *)getNumFromString:(NSMutableArray *)wordsTemp :(NSString *)signString
{
    NSMutableArray *tempMuArr= [[NSMutableArray alloc]init];
    for (int i=0; i<[wordsTemp count];i++) {
        if ([[NSString stringWithFormat:@"%@",[wordsTemp objectAtIndex:i]] isEqualToString:signString]) {
            [tempMuArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return tempMuArr;
}

+(NSString *)getRandom
{
    NSString *tempS;

    UIDevice *device_=[[UIDevice alloc] init];
    NSString *devicesySystemVersion= [NSString stringWithFormat:@"Iphone %@",device_.systemVersion];
    NSString *devicesyUuid=device_.identifierForVendor.UUIDString;
    NSString *macAddress=@"0";
    NSString *randomStr=[NSString stringWithFormat:@"%d",arc4random() % 9999];
    tempS=[NSString stringWithFormat:@"%@+%@+%@+%@",devicesySystemVersion,devicesyUuid,macAddress,randomStr];
    NSLog(@"tempS=%@",tempS);
    return tempS;
}

//#pragma mark MAC
//+ (NSString *)macaddress
//{
//    int                    mib[6];
//    size_t                len;
//    char                *buf;
//    unsigned char        *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl    *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        return NULL;
//    }
//
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    
//    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//    return [outstring uppercaseString];
//    
//}


#pragma mark IP
//***********************   IP地址  **************************//

#define MAXADDRS    32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE  4000

char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

void InitAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

void FreeAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
{
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
    InitAddresses();
}

//void GetIPAddresses()
//{
//    int                 i, len, flags;
//    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
//    struct ifconf       ifc;
//    struct ifreq        *ifr, ifrcopy;
//    struct sockaddr_in  *sin;
//    
//    char temp[80];
//    
//    int sockfd;
//    
//    for (i=0; i<MAXADDRS; ++i)
//    {
//        if_names[i] = ip_names[i] = NULL;
//        ip_addrs[i] = 0;
//    }
//    
//    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
//    if (sockfd < 0)
//    {
//        perror("socket failed");
//        return;
//    }
//    
//    ifc.ifc_len = BUFFERSIZE;
//    ifc.ifc_buf = buffer;
//    
//    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
//    {
//        perror("ioctl error");
//        return;
//    }
//    
//    lastname[0] = 0;
//    
//    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
//    {
//        ifr = (struct ifreq *)ptr;
//        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
//        ptr += sizeof(ifr->ifr_name) + len;   // for next one in buffer
//        
//        if (ifr->ifr_addr.sa_family != AF_INET)
//        {
//            continue; // ignore if not desired address family
//        }
//        
//        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
//        {
//            *cptr = 0;        // replace colon will null
//        }
//    
//        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
//        {
//            continue; /* already processed this interface */
//        }
//    
//        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
//        
//        ifrcopy = *ifr;
//        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
//        flags = ifrcopy.ifr_flags;
//        if ((flags & IFF_UP) == 0)
//        {
//            continue; // ignore if interface not up
//        }
//        
//        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
//        if (if_names[nextAddr] == NULL)
//        {
//            return;
//        }
//        strcpy(if_names[nextAddr], ifr->ifr_name);
//    
//        sin = (struct sockaddr_in *)&ifr->ifr_addr;
//        strcpy(temp, inet_ntoa(sin->sin_addr));
//        
//        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
//        if (ip_names[nextAddr] == NULL)
//        {
//            return;
//        }
//        strcpy(ip_names[nextAddr], temp);
//        
//        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
//        
//        ++nextAddr;
//    }
//    
//    close(sockfd);
//}
//
//void GetHWAddresses()
//{
//    struct ifconf ifc;
//    struct ifreq *ifr;
//    int i, sockfd;
//    char buffer[BUFFERSIZE], *cp, *cplim;
//    char temp[80];
//    
//    for (i=0; i<MAXADDRS; ++i)
//    {
//        hw_addrs[i] = NULL;
//    }
//    
//    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
//    if (sockfd < 0)
//    {
//        perror("socket failed");
//        return;
//    }
//    ifc.ifc_len = BUFFERSIZE;
//    ifc.ifc_buf = buffer;
//    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0)
//    {
//        perror("ioctl error");
//        close(sockfd);
//        return;
//    }
////    ifr = ifc.ifc_req;
//    
//    cplim = buffer + ifc.ifc_len;
//    
//    for (cp=buffer; cp < cplim; )
//    {
//        ifr = (struct ifreq *)cp;
//        if (ifr->ifr_addr.sa_family == AF_LINK)
//        {
//            //            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
//            int a,b,c,d,e,f;
//            int i;
//            
//            //            strcpy(temp, (char *)ether_ntoa((const struct ether_addr *)LLADDR(sdl)));
//            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
//            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
//            
//            for (i=0; i<MAXADDRS; ++i)
//            {
//                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name, if_names[i]) == 0))
//                {
//                    if (hw_addrs[i] == NULL)
//                    {
//                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
//                        strcpy(hw_addrs[i], temp);
//                        break;
//                    }
//                }
//            }
//        }
//        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
//    }
//    close(sockfd);
//}
//
//+ (NSString *)deviceIPAdress
//{
//    InitAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    return [NSString stringWithFormat:@"%s", ip_names[1]];
//}

+(int)getPageNum:(NSUInteger)arrayCount :(NSInteger)numPage
{
    int tempPageNum=0;
    if (arrayCount%numPage==0)
    {
        tempPageNum=(int)arrayCount/numPage+1;
    }
    return tempPageNum;
}

+(CGFloat)getHightFrame:(id)sender
{
    CGFloat tempF =0;
    UIView *tempView = (UIView *)sender;
    tempF = tempView.frame.size.height+tempView.frame.origin.y;
    return tempF;
}

+(void)clearKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

//清除所有键盘
+(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

+(CGSize)getFontSize:(UILabel *)tempLabel :(CGFloat)tempWith
{
    CGSize textSize=[tempLabel.text boundingRectWithSize:CGSizeMake(tempWith, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: tempLabel.font} context:nil].size;
    return textSize;
}

//  -----------------------------------------------------------------------------XMPP封装方法
//  广播消息
//+(void)sendSystemMessage:(NSString *)phoneNum :(NSString *)messageData
//{
//    if ([[kAppDelegate xmppStream] isConnected])
//    {
//        XMPPJID *tempBarJid=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",phoneNum,kHostName]];
//        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:tempBarJid];
//        [message addBody:[NSString stringWithFormat:@"%@%@",kCheckTarget,messageData]];
//        [kAppDelegate setBarJID:tempBarJid];
//        [[kAppDelegate xmppStream] sendElement:message];
//    }
//}

//  群消息


//+(void)sendPhoneToServer
//{
//    if (INITSENDPHONE) {
//        NSLog(@"正在上传不要急");
//        return;
//    }
//    
//    if (HASLOGIN)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sendphone"];
//        NSMutableArray *phoneMuArray = [[NSMutableArray alloc] init];   //  缓存电话
//        [phoneMuArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneListApp"]];
//        NSMutableArray *infoPhone = [[NSMutableArray alloc] init];  //  通讯录电话
//        @try {
//            [infoPhone addObjectsFromArray:[ConvertValue initInfo]];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"通讯录获取不到");
//            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sendphone"];
//            return;
//        }
//        if ([infoPhone count]==0)   //  通讯录获取不到就不发送
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sendphone"];
//            NSLog(@"通讯录获为空");
//            return;
//        }
//        NSMutableArray *tempPhone = [[NSMutableArray alloc] init];  //复制通讯录电话
//        if ([phoneMuArray count]>0)
//        {
//            for (int i=0; i<[infoPhone count]; i++)
//            {
//                for (int j=0; j<[phoneMuArray count]; j++)
//                {
//                    if ([[infoPhone objectAtIndex:i] isEqualToString:[phoneMuArray objectAtIndex:j]])
//                    {
//                        break;//  相等就不管退出本轮循环
//                    }
//                    if (j==[phoneMuArray count]-1)//遍历完了
//                    {
//                        [tempPhone addObject:[infoPhone objectAtIndex:i]];
//                    }
//                }
//            }
//        }
//        else
//        {
//            tempPhone =infoPhone;
//        }
//        if ([tempPhone count]==0)
//        {
//            NSLog(@"通讯录和缓存一致");
//            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sendphone"];
//            return;
//        }
//        [phoneMuArray addObjectsFromArray:tempPhone];   // 把不相同的号码加载到缓存
//        NSString *tempS;      //发送新增的缓存
//        
//        for (int i=0; i<[tempPhone count]; i++)
//        {
//            if ([ConvertValue isNULL:tempS])
//            {
//                tempS=[tempPhone objectAtIndex:i];
//            }
//            else
//            {
//                tempS = [NSString stringWithFormat:@"%@,%@",tempS,[tempPhone objectAtIndex:i]];
//            }
//        }
//        
//        NSLog(@"准备正在上传通讯录==%@",tempS);
//
//        [HttpTool postWithBaseURL:[NSString stringWithFormat:@"http://%@/",TRADEIPURL] path:@"app/circle/add_contact" params:@{@"uid":UID,@"contact":tempS} success:^(NSDictionary *dict) {
//            
//            @try
//            {
//                if (dict==nil)
//                {
//                    [SVProgressHUD showErrorWithStatus:ERRORTITLE duration:2];
//                    return ;
//                }
//                if ([[dict objectForKey:@"status"] intValue]==1)
//                {
//                    NSLog(@"电话号码上传成功");
//                    [[NSUserDefaults standardUserDefaults] setObject:phoneMuArray forKey:@"phoneListApp"];
//                }
//                else
//                {
//                    NSLog(@"电话号码上传失败");
//                }
//            }
//            @catch (NSException *exception)
//            {
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }
//}

+(void)downLoadImg:(NSString *)url
{
    NSString *fileName = [url lastPathComponent];
//    if ([ConvertValue isNULL:fileName]||[fileName isEqualToString:TRADEIPURL])
//    {
//        NSLog(@"不能下载:%@,%@",url,fileName);
//        return;
//    }
    
    NSLog(@"下载开始:%@,%@",url,fileName);
    if (![ConvertValue hasDownLoad:fileName])
    {
        UIImageFromURLBase([NSURL URLWithString:url], ^( NSData *data )
           {
               NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageArrayDown"];
               NSMutableArray *tempMuArray = [[NSMutableArray alloc] initWithArray:tempArray];
               [tempMuArray addObject:fileName];
               tempArray=tempMuArray;
               [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"imageArrayDown"];
               [[NSUserDefaults standardUserDefaults] setObject:data forKey:fileName];
               NSLog(@"下载成功:%@,%@",url,fileName);
           }, ^(void)
           {
               NSLog(@"图片下载失败:%@,%@",url,fileName);
           });
    }
}

+(BOOL)hasDownLoad:(NSString *)imgName
{
    if (imgName==nil) {
        return NO;
    }
    NSData *tempImg;
    @try {
        tempImg = [[NSUserDefaults standardUserDefaults] objectForKey:imgName];
    }
    @catch (NSException *exception) {
        tempImg=nil;
    }
    if (tempImg==nil) {
        return NO;
    }
    UIImage *tempImage = [[UIImage alloc] initWithData:tempImg];
    @try
    {
        if (tempImage!=nil)
        {
            return YES;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
    return NO;
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
#pragma mark - 下载图片
void UIImageFromURLBase( NSURL * URL, void (^imageBlock)(NSData * data), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
       {
           NSData *data = [[NSData alloc] initWithContentsOfURL:URL] ;
           UIImage *tempImage = [[UIImage alloc] initWithData:data];
           
           dispatch_async( dispatch_get_main_queue(), ^(void){
               if( tempImage != nil )
               {
                   imageBlock(data);
               }
               else
               {
                   errorBlock();
               }
           });
       });
}

+ (void)scrollTableToNum:(BOOL)animated :(NSInteger)num :(UITableView *)tempTabele
{
    NSInteger s = [tempTabele numberOfSections];
    if (s<1){ return;}
    NSInteger r = [tempTabele numberOfRowsInSection:s-1];
    if (r<1) {return;}
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-num inSection:s-1];
    [tempTabele scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
