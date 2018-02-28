# Sinch-Calling-App-to-App-swift-4
Calling by Sinch frame work on voip

Sinch-Calling-App-to-App-swift-4 is a sample application for app to app calling using Sinch framework (https://www.sinch.com/). This application is similar to the application you get while you download Sinch SDK from official website, but this is written in Swift.

Steps to Run this app:

1) Go to the project directory location in terminal & run pod install which will install the necessary dependency.

2) Register yourself at Sinch.

3) Register your app in Sinch, you'll get the Application Key and Secret.

4) Paste the Application Key & Secret in initSinchClientWithUserId method of AppDelegate.

5) That's it Go Ahead & Run.


If You want to use it directly by just drag and drop frame work, its simple, just download (www.sinch.com/download/) latest framework of Sinch and add it to your exsiting frame works.

# Frameworks required for calling
1) libc++.dylib (libc++.tbd)
2) libz.tbd
3) Security.framework
4) AVFoundation.framework
5) AudioToolbox.framework
6) VideoToolbox.framework
7) CoreMedia.framework
8) CoreVideo.framework 
9) CoreImage.framework
10) GLKit.framework
11) OpenGLES.framework
12) QuartzCore.framework

# INFO.PLIST
Required background modes 
1) Application plays audio (audio))
2) Application provides Voice over IP services (voip)
3) Privacy - Microphone Usage Description (NSMicrophoneUsageDescription)

# CREATING THE SINCLIENT

 1) var client: SINClient!
 2) client = Sinch.client(withApplicationKey: "<application key>",
 3)                     applicationSecret: "<application secret>",
 4)                     environmentHost: "sandbox.sinch.com",
 5)                      userId: "<user id>")


# SPECIFYING CAPABILITIES
            client.setSupportCalling(true)

# STARTING THE SINCH CLIENT
            client.start()
            client.startListeningOnActiveConnection()


To Update Sinch SDK in future :

As Sinch SDK is installed via. CocoaPod, all we need to do to is run pod update for the project.




