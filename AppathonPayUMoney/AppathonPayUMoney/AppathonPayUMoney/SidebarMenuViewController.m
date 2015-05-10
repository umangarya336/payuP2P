//
//  SidebarMenuViewController.m
//  DPRSDPRSAppIphone
//
//  Created by MANOJ VERMA on 30/01/15.
//
//

#import "SidebarMenuViewController.h"

@implementation SidebarMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:188.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    self.navigationController.navigationBarHidden = true;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:188.0/255.0 blue:232.0/255.0 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //add first view controller
    [self addTargetViewControllerForIndex:0];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRight];
    
    
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    //open sidebar ...
    
    float distanceToMove = 250.0f;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        
        self.containerController.view.frame = CGRectMake(distanceToMove, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
    }];
}

-(void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //close side bar ...
    
    [UIView animateWithDuration:0.3f animations:^(void){
        
        self.containerController.view.frame = CGRectMake(0.0f, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
    }];
}


#pragma mark - private class methods

- (void)addShadowToViewController:(UIViewController *)viewController {
    
    [viewController.view.layer setCornerRadius:4];
    
    [viewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [viewController.view.layer setShadowOpacity:0.8];
    
    [viewController.view.layer setShadowOffset:CGSizeMake(-2, -2)];
}


#pragma mark - public class methods

- (void)addTargetViewControllerForIndex:(NSUInteger)index {
    
    //fetch the target view controller
    UIViewController *currentViewController = [self.menuItemViewControllers objectAtIndex:index];
    
    //add a sidebar button to the target view controller
    [self addSidebarButtonForViewController:currentViewController];
    
    
    if([[self.containerController childViewControllers] count] > 0) {
        
        [self removeTargetViewController];
        
        [self.containerController pushViewController:currentViewController animated:NO];
        if (index > 0) {
            currentViewController.title = [self.menuItemNames objectAtIndex:index];
        }
    }
    else {
        
        //instantiate navigation controller container with chosen view controller
        self.containerController = [[UINavigationController alloc] initWithRootViewController:currentViewController];
        
        //add a shadow to the navigation controller container
        [self addShadowToViewController:self.containerController];
        
        //add the container controller as a child view controller to this view controller
        [self addChildViewController:self.containerController];
        
        [self.view addSubview:self.containerController.view];
        
        [self.containerController didMoveToParentViewController:self];
        if (index > 0) {
            currentViewController.title = [self.menuItemNames objectAtIndex:index];
        }
    }
}

- (void)removeTargetViewController {
    
    NSArray *childViewContorllersOfContainer = [self.containerController childViewControllers];
    
    UIViewController *theChildViewController = [childViewContorllersOfContainer lastObject];
    
    [theChildViewController removeFromParentViewController];
}

- (void)addSidebarButtonForViewController:(UIViewController *)viewController {
    
    //create the sidebar button
    UIButton *sidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"menu-button.png"];
    
    [sidebarButton setImage:image forState:UIControlStateNormal];
    
    [sidebarButton setShowsTouchWhenHighlighted:YES];
    
    sidebarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    //add left bar button
    UIBarButtonItem *sidebarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sidebarButton];
    
    [sidebarButton addTarget:self action:@selector(toggleSidebar:) forControlEvents:UIControlEventTouchUpInside];
    
    viewController.navigationItem.leftBarButtonItem = sidebarButtonItem;
}

- (void)toggleSidebar:(id)obj {
    
    //get the position
    float xPosition = self.containerController.view.frame.origin.x;
    
    //toggle the side bar
    if(xPosition > 0.0f) {
        
        //close side bar ...
        
        [UIView animateWithDuration:0.3f animations:^(void){
            
            self.containerController.view.frame = CGRectMake(0.0f, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
        }];
    }
    else {
        
        //open sidebar ...
        
        float distanceToMove = 250.0f;
        
        [UIView animateWithDuration:0.3f animations:^(void){
            
            self.containerController.view.frame = CGRectMake(distanceToMove, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
        }];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.menuItemNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:188.0/255.0 blue:232.0/255.0 alpha:1.0];
    cell.textLabel.text = [self.menuItemNames objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addTargetViewControllerForIndex:indexPath.row];
    [self toggleSidebar:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
