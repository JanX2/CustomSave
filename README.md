# CustomSave

March 20, 2013

“CustomSave” is a Cocoa sample application that demonstrates how to
customize the NSSavePanel class. The sample uses an NSDocument context, but most of the techniques apply more generally.

## Sample Requirements

The supplied Xcode project was created using Xcode v4.6 running under
Mac OS X 10.7.x or later. The project will create a Universal Binary.


## About the Sample

Customization is achieved by implementing


NSDocument

    - (BOOL)prepareSavePanel:(NSSavePanel *)savePanel;

This will set the initial directory, add a custom accessory view, set
the required extension, set the name field label and dialog message.


NSSavePanelDelegate

    - (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError
    **)outError
    
    - (NSString *)panel:(id)sender userEnteredFilename:(NSString*)filename
    confirmed:(BOOL)okFlag;
    
    - (void)panel:(id)sender willExpand:(BOOL)expanding;
    
    - (void)panel:(id)sender directoryDidChange:(NSString *)path;
    
    - (void)panelSelectionDidChange:(id)sender;
    
    - (NSComparisonResult)panel:(id)sender compareFilename:(NSString
    *)name1 with:(NSString *)name2 caseSensitive:(BOOL)caseSensitive;


As a delegate to the NSSavePanel, this sample provides sound feedback
for navigation, allows navigating inside packages, and overrides how a
file's saved name is determined.


## Using the Sample

Simply build and run the sample using Xcode, create and save a text
document.

## Changes from Previous Versions

A lot. See commit history on github.

## Feedback and Bug Reports

Please send all feedback about this sample by connecting to the [Contact
ADC](http://developer.apple.com/contact/feedback.html) page.

Please submit any bug reports about this sample to the [Bug
Reporting](http://developer.apple.com/bugreporter) page.


## Developer Technical Support

The Apple Developer Connection Developer Technical Support (DTS) team is
made up of highly qualified engineers with development expertise in key
Apple technologies. Whether you need direct one-on-one support
troubleshooting issues, hands-on assistance to accelerate a project, or
helpful guidance to the right documentation and sample code, Apple
engineers are ready to help you.  Refer to the [Apple Developer
Technical Support](http://developer.apple.com/technicalsupport/) page.

Copyright © 2007 Apple Inc. All rights reserved.

Updated 2013 by Jan Weiß
