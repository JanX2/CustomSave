/*

File: MyDocument.m

Abstract: Source file for the saved text document.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the
following terms, and your use, installation, modification or
redistribution of this Apple software constitutes acceptance of these
terms.  If you do not agree with these terms, please do not use,
install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software. 
Neither the name, trademarks, service marks or logos of Apple Inc.
may be used to endorse or promote products derived from the Apple
Software without specific prior written permission from Apple.  Except
as expressly stated in this notice, no other rights or licenses, express
or implied, are granted by Apple herein, including but not limited to
any patent rights that may be infringed by your derivative works or by
other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright © 2007 Apple Inc., All Rights Reserved

*/

#import "MyDocument.h"

@implementation MyDocument

@synthesize textView = _textView;
@synthesize model = _model;
@synthesize savePanel = _savePanel;
@synthesize saveDialogCustomView = _saveDialogCustomView;

@synthesize soundOnCheck = _soundOnCheck;
@synthesize appendCheck = _appendCheck;
@synthesize navigatePackagesCheck = _navigatePackagesCheck;

@synthesize soundOn = _soundOn;
@synthesize appendMark = _appendMark;
@synthesize navigatePackages = _navigatePackages;

- (id)init
{
	self = [super init];
	
	if (nil != self) {
		_soundOn = YES;
		_appendMark = YES;
		_navigatePackages = YES;
		
		[_savePanel setTreatsFilePackagesAsDirectories:_navigatePackages];
	}
	
	return self;
}

- (void)dealloc
{
	[_model release];

	[_savePanel release];
	
	[super dealloc];
}


// -------------------------------------------------------------------------------
// windowNibName:
// -------------------------------------------------------------------------------
- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers,
	// you should remove this method and override -makeWindowControllers instead.
	// ..
	return @"MyDocument";
}

// -------------------------------------------------------------------------------
// windowControllerDidLoadNib:aController
// -------------------------------------------------------------------------------
- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];

	// Add any code here that need to be executed once the windowController has loaded the document's window.
	// ..

	// the following code adds the horizontal scroll bar to the scroll view and makes the text view horizontally
	// resizable so it can display text of any width:
	//
	NSRect frameRect;
	NSWindow *theWindow = [(NSView *)_textView window];

	//frameRect = [(NSView*)_textView frame];

	NSScrollView *scrollview = [_textView enclosingScrollView];

	NSSize contentSize = [scrollview contentSize];
	[scrollview setBorderType:NSNoBorder];
	[scrollview setHasVerticalScroller:YES];
	[scrollview setHasHorizontalScroller:YES];    // for horizontal scrolling

	[scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	frameRect = NSMakeRect(0, 0, contentSize.width, contentSize.height);
	[_textView setFrame:frameRect];

	[_textView setMinSize:NSMakeSize(contentSize.width, contentSize.height)];
	[_textView setMaxSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];

	[_textView setVerticallyResizable:YES];
	[_textView setHorizontallyResizable:YES];    // for horizontal scrolling
	[_textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];    // for horizontal scrolling
	[[_textView textContainer] setContainerSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];    // for horizontal scrolling
	[[_textView textContainer] setWidthTracksTextView:NO];                        // for horizontal scrolling

	[scrollview setDocumentView:_textView];
	[theWindow setContentView:scrollview];
	[theWindow makeKeyAndOrderFront:nil];
	[theWindow makeFirstResponder:_textView];

	[self updateView];
}

// -------------------------------------------------------------------------------
// dataOfType:typeName:error
// -------------------------------------------------------------------------------
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	// return a data object that contains the contents of the document
	[self updateModel];
	return _model;
}

// -------------------------------------------------------------------------------
// readFromData:data:typeName:error
// -------------------------------------------------------------------------------
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	// set the contents of this document by reading from data of a specified type
	[self setModel:data];
	[self updateView];
	return YES;
}

// -------------------------------------------------------------------------------
// entireRange:
// -------------------------------------------------------------------------------
- (NSRange)entireRange
{
	return NSMakeRange(0, [[_textView string] length]);
}

// -------------------------------------------------------------------------------
// updateModel:
// -------------------------------------------------------------------------------
- (void)updateModel
{
	[self setModel:[_textView RTFFromRange:[self entireRange]]];
}

// -------------------------------------------------------------------------------
// updateView:
// -------------------------------------------------------------------------------
- (void)updateView
{
	[_textView replaceCharactersInRange:[self entireRange] withRTF:[self model]];
}


#pragma mark Save Dialog Stuff

// -------------------------------------------------------------------------------
// prepareSavePanel:inSavePanel:
// -------------------------------------------------------------------------------
// Invoked by runModalSavePanel to do any customization of the Save panel savePanel.
//
- (BOOL)prepareSavePanel:(NSSavePanel *)inSavePanel
{
	// here we explicitly want to always start in the user's home directory,
	// If we don't set this, then the save panel will remember the last visited
	// directory, which is generally preferred.
	//
	[inSavePanel setDirectoryURL:[NSURL fileURLWithPath:NSHomeDirectory()]];

	[inSavePanel setDelegate:self];    // allows us to be notified of save panel events

	[inSavePanel setMessage:@"This is a customized save dialog for saving text files:"];
	[inSavePanel setAccessoryView:_saveDialogCustomView];    // add our custom view
	[inSavePanel setAllowedFileTypes:[NSArray arrayWithObjects:(NSString *)kUTTypeRTF, nil]];
	[inSavePanel setNameFieldLabel:@"FILE NAME:"];            // override the file name label

	self.savePanel = inSavePanel;    // keep track of the save panel for later
	[_savePanel setTreatsFilePackagesAsDirectories:_navigatePackages];

	return YES;
}

// -------------------------------------------------------------------------------
// compareFilename:name1:name2:caseSensitive:
// -------------------------------------------------------------------------------
// Controls the ordering of files presented by the NSSavePanel object sender.
//
// Don’t reorder filenames in the Save panel without good reason, because it may confuse the user
// to have files in one Save panel or Open panel ordered differently than those in other such panels
// or in the Finder. The default behavior of Save and Open panels is to order files as they appear in the Finder.
//
// Note also that by implementing this method you will reduce the operating performance of the panel.
//
- (NSComparisonResult)panel:(id)sender compareFilename:(NSString *)name1 with:(NSString *)name2 caseSensitive:(BOOL)caseSensitive
{
	// do the normal compare
	return [name1 compare:name2];
}

// -------------------------------------------------------------------------------
// isValidFilename:filename:
// -------------------------------------------------------------------------------
// Gives the delegate the opportunity to validate selected items.
//
// The NSSavePanel object sender sends this message just before the end of a modal session for each filename
// displayed or selected (including filenames in multiple selections). The delegate determines whether it
// wants the file identified by filename; it returns YES if the filename is valid, or NO if the save panel
// should stay in its modal loop and wait for the user to type in or select a different filename or names.
// If the delegate refuses a filename in a multiple selection, none of the filenames in the selection is accepted.
//
// In this particular case: we arbitrary make sure the save dialog does not allow files named as "text"
//
- (BOOL)panel:(id)sender isValidFilename:(NSString *)filename
{
	BOOL result = YES;

	NSURL *url = [NSURL fileURLWithPath:filename];
	if (url && [url isFileURL]) {
		NSArray *pathPieces = [[url path] pathComponents];
		NSString *actualFilename = [pathPieces objectAtIndex:[pathPieces count] - 1];
		if ([actualFilename isEqual:@"text.txt"]) {
			NSAlert *alert = [NSAlert alertWithMessageText:@"Cannot save a file with the name \"text\"."
											 defaultButton:@"OK"
										   alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please pick another name."];
			[alert runModal];
			result = NO;
		}
	}

	return result;
}

// -------------------------------------------------------------------------------
// userEnteredFilename:filename:confirmed:okFlag
// -------------------------------------------------------------------------------
// Sent when the user confirms a filename choice by hitting OK or Return in the NSSavePanel object sender.
//
// You can either leave the filename alone, return a new filename, or return nil to cancel the save
// (and leave the Save panel as is). This method is sent before any required extension is appended to the
// filename and before the Save panel asks the user whether to replace an existing file.
//
// In this particular case, we arbitrarily add a "!" to the end of the file name.
//
- (NSString *)panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag
{
	if (okFlag && _appendMark) {
		NSString *fileBaseName = [filename stringByDeletingPathExtension];
		NSString *fileNameExtension = [filename pathExtension];
		return [[fileBaseName stringByAppendingString:@"!"] stringByAppendingPathExtension:fileNameExtension];
	}
	return filename;
}

// -------------------------------------------------------------------------------
// willExpand:expanding
// -------------------------------------------------------------------------------
// Sent when the NSSavePanel object sender is about to expand or collapse because the user clicked the
// disclosure triangle that displays or hides the file browser.
//
// In this particular case, we have sound feedback for expand/shrink of the save dialog.
//
- (void)panel:(id)sender willExpand:(BOOL)expanding
{
	if (_soundOn) {
		if (expanding)
			[[NSSound soundNamed:@"Pop"] play];
		else
			[[NSSound soundNamed:@"Blow"] play];
	}

	// package navigation doesn't apply for the shrunk/simple dialog
	[_navigatePackagesCheck setHidden:!expanding];
}

// -------------------------------------------------------------------------------
// directoryDidChange:path
// -------------------------------------------------------------------------------
// Sent when the user has changed the selected directory in the NSSavePanel object sender.
//
// In this particular case, we have sound feedback for directory changes.
//
- (void)panel:(id)sender directoryDidChange:(NSString *)path
{
	if (_soundOn)
		[[NSSound soundNamed:@"Frog"] play];
}

// -------------------------------------------------------------------------------
// panelSelectionDidChange:sender
// -------------------------------------------------------------------------------
// Sent when the user has changed the selection in the NSSavePanel object sender.
//
// In this particular case, we have sound feedback for selection changes.
//
- (void)panelSelectionDidChange:(id)sender
{
	if (_soundOn)
		[[NSSound soundNamed:@"Hero"] play];
}

// -------------------------------------------------------------------------------
// filePackagesAsDirAction:sender
// -------------------------------------------------------------------------------
// toggles flag via custom checkbox to view packages
//
- (IBAction)filePackagesAsDirAction:(id)sender
{
	[_savePanel setTreatsFilePackagesAsDirectories:_navigatePackages];
}

@end
