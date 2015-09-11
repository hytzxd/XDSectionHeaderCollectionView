//
//  ViewController.m
//  SectionCollectionView
//
//  Created by 张旭东 on 15/9/9.
//  Copyright (c) 2015年 张旭东. All rights reserved.
//

#import "ViewController.h"
#import "SectionHeadercCollectionViewLayout.h"
@interface ViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)NSArray *sectionColor;
@end
static NSString * const cellIndentifier = @"cellIndentifier";
static NSString * const sectionIndentifier = @"sectionHeaderIndentifier";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self makeView];
    self.sectionColor  = @[[UIColor redColor],
                           [UIColor orangeColor],
                           [UIColor greenColor],
                           [UIColor yellowColor],
                           [UIColor grayColor],
                           [UIColor blueColor],
                           [UIColor purpleColor]];
    
}
- (void)makeView{
    if (self.collectionView)return;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout  = [[SectionHeadercCollectionViewLayout alloc]init];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    CGFloat itemWidth = (([UIScreen mainScreen].bounds.size.width - 20) - 6 * 10) / 5.f;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIndentifier];
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_collectionView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *sectionHeaderView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIndentifier forIndexPath:indexPath];
//        UIColor *sectionHeaderColoer = [UIColor colorWithRed:255 / 19.f * indexPath.section / 255 green:255 / 19.f * indexPath.section / 255  blue:255.f / 19 * indexPath.section / 255  alpha:1.0];
        NSInteger index = MIN(6, indexPath.section % 20);
        
        sectionHeaderView.backgroundColor = self.sectionColor[index];
        return sectionHeaderView;
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];//99,237,204
    NSInteger index = MIN(6, indexPath.row % 20);
    
   
    cell.backgroundColor = self.sectionColor[index];;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 30;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 37;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 60);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [self makeView];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%@",[self.collectionView visibleCells]);
}

@end
