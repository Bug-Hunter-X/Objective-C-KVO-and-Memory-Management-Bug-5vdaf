The solution is to always remove observers using `removeObserver:` when they are no longer needed.  Here's the corrected code:

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

        [obj removeObserver:observer forKeyPath:@"myString"];

        obj = nil; // This will deallocate obj without a crash
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    return 0;
}
```
This corrected version explicitly removes the observer before the `obj` is released, preventing the potential crash.