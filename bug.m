In Objective-C, a tricky bug can arise from the interaction between KVO (Key-Value Observing) and memory management. If an observer is not removed properly when it's no longer needed, it can lead to crashes or unexpected behavior. This is especially true if the observed object is deallocated while the observer is still registered.  For example:

```objectivec
@interface MyObject : NSObject
@property (nonatomic, strong) NSString *myString;
@end

@implementation MyObject
- (void)dealloc {
    NSLog(@"MyObject deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"Observed change: %@
", change);
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyObject *obj = [[MyObject alloc] init];
        MyObserver *observer = [[MyObserver alloc] init];
        [obj addObserver:observer forKeyPath:@"myString" options:NSKeyValueObservingOptionNew context:NULL];

        obj.myString = @"Hello";

        //Missing removeObserver call
        // [obj removeObserver:observer forKeyPath:@"myString"];

        obj = nil; // This will deallocate obj
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    return 0;
}
```
In this example,  if `removeObserver:` isn't called before `obj` is set to `nil`, the observer will still try to access deallocated memory when the `myString` property changes, resulting in a crash.