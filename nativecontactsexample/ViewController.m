//
//  ViewController.m
//  nativecontactsexample
//
//  Created by Andreas Karpinski on 02.03.20.
//  Copyright © 2020 Andreas Karpinski. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

    __block BOOL accessGranted = NO;
    
   if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    if (accessGranted) {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);

        assert(nPeople > 0);
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, 0);
        CFStringRef note = ABRecordCopyValue(ref, kABPersonNoteProperty);
        
        assert(note != NULL);
    }
}


@end
