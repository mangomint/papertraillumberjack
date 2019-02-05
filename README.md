# PaperTrailLumberjack
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

PaperTrailLumberjack is a CocoaLumberjack logger that helps log statements to your log destination at [papertrailapp](http://papertrailapp.com).
It can log using TCP and UDP - the default, being TCP (with TLS).

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Example UDP logging:

    RMPaperTrailLogger *paperTrailLogger = [RMPaperTrailLogger sharedInstance];
    paperTrailLogger.host = @"destination.papertrailapp.com"; //Your host here
    paperTrailLogger.port = 9999; //Your port number here    
    paperTrailLogger.useTcp = NO;
    [DDLog addLogger:paperTrailLogger];
    DDLogVerbose(@"Hi PaperTrailApp.com);

Example TCP logging (with TLS):

    RMPaperTrailLogger *paperTrailLogger = [RMPaperTrailLogger sharedInstance];
    paperTrailLogger.host = @"destination.papertrailapp.com"; //Your host here
    paperTrailLogger.port = 9999; //Your port number here    
    [DDLog addLogger:paperTrailLogger];
    DDLogVerbose(@"Hi PaperTrailApp.com");

Your log messages are automatically formatted to meet the syslog specs, which, typically haves a machine name and program name pre-fixed to the log, along with a timestamp. In order to maintain user privacy, PaperTrailLumberjack uses a unique UUID per device (the UUID is random and reset each time the application is deleted and installed again). The program name is the bundle name stripped of whitespaces.

Sample log output:

    May 08 23:20:59 0A3F9C64-D271-452F-AD6E-8052BBD3F789 PaperTrailLumberjackiOSExample: 60b PaperTrailLumberjackiOSExampleTests@testUdpLogging@62 "Hi PaperTrailApp.com"

By default, PaperTrailLumberjack uses a UUID for machine name and the application's bundle display name for it's program name. These can be overriden, as follows

    paperTrailLogger.machineName = @"My Custom Machine";
    paperTraiLogger.programName = @"My Program";

Whitespace (if any) in user defined machine and program names will be removed before logging. Sample output

    May 08 23:20:59 MyCustomMachine MyProgram: 60b PaperTrailLumberjackiOSExampleTests@testUdpLogging@62 "Hi PaperTrailApp.com"

Prior to v0.1.9, PapertrailLumberjack would format the messages with an older syslog format (RFC3164). We now, format them with RFC5424 as default. If you would like to go back to the older format, you can set it on the logger instance.

    paperTrailLogger.syslogRFCType = RMSyslogRFCType3164;

## Caveat: messages may be lost, logging may stop entirely

### When using UDP: some messages may be lost

UDP is inherently lossy, and there is no guarantee that the messages will reach the logging host, so expect some log messages to be lost.

### When using TCP: logging may stop entirely

With TCP logging, PaperTrailLumberjack opens a TCP connection when the first log message is sent. It then reuses this connection for later messages. But various issues may cause the connection to drop, and all logging will stop until the app is restarted.

To alleviate this, you need to tell PaperTrailLumberjack to reopen the connection. Since backgrounding of the app (on iOS) or machine going to sleep (on macOS) will always close the connection, a good place to reopen the connection is `applicationWillEnterForeground` (on iOS), **TODO: or ...? (on macOS).** You can also monitor network reachability and reopen the connection when the network comes back up. But be aware that the connection may still drop for other reasons. To tell PaperTrailLumberjack to reopen the connection:

    # In Objective C:
    [paperTrailLogger performSelector:connectTcpSocket]; // <-------- TODO: confirm this is correct

    # In Swift:
    paperTrailLogger.perform(Selector(("connectTcpSocket")))

Note that PaperTrailLumberjack does not do any caching or buffering: log messages sent while the connection was down will be lost.

PaperTrailLumberjack also offers an **experimental** auto-reconnect mode, where it will automatically attempt to reopen the connection. Logs sent while the connection is down will still be lost, but logging will automatically resume after the connection has been reestablished. Be aware that it can be resource intensive, since while the connection is down, PaperTrailLumberjack will attempt to reopen the connection for every log message. Under bad network conditions, this might end up taking away network resources from the main app. This feature is experimental, so use it at your own risk. To enable it:

    paperTrailLogger.autoReconnect = YES;

## Requirements

   iOS 8 or later
   
   MacOS 10.10 or later
   
## Installation

PaperTrailLumberjack can be installed by multiple methods

1. PaperTrailLumberjack is available through [CocoaPods](http://cocoapods.org) 

    To install it,

    + **Objective-C** Projects
   
    Add the following line to your Podfile:

        use_frameworks!
        
        target "YourTargetName" do
           pod "PaperTrailLumberjack"
        end


    In your project, import the PaperTrailLumberJack header

        import <PaperTrailLumberjack/PaperTrailLumberjack.h>


    + **Swift** projects, 

    Add the following lines to your Podfile:

        use_frameworks!
        
        target "YourTargetName" do
           pod "PaperTrailLumberjack/Swift"
        end

    In your project, import PaperTrailLumberJack
   
        import PaperTrailLumberjack


2. Via [Carthage](https://github.com/Carthage/Carthage)

    Carthage is a light-weight dependency manager, that is a lot less intrusive, as compared to Cocoapods. To install with Carthage,
add the following entry into your Cartfile and follow the instructions listed [here](https://github.com/Carthage/Carthage)

        git "https://bitbucket.org/rmonkey/papertraillumberjack.git"
        
    You will have to do a non-binary build with Carthage (as otherwise CocoaLumberjack-Swift is not built)
    
        carthage update --no-use-binaries


## Author

George Malayil-Philip, [george.malayil@roguemonkey.in](mailto:george.malayil@roguemonkey.in)

[Rogue Monkey Technologies & Systems Private Limited](http://www.roguemonkey.in)

## License

PaperTrailLumberjack is available under the MIT license. See the LICENSE file for more info.

