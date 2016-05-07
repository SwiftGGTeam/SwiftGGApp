//
//  Logger+Rx.swift
//  GGQ
//
//  Created by 宋宋 on 5/4/16.
//  Copyright © 2016 org.dianqk. All rights reserved.
//

import UIKit
import RxSwift

#if DEV
    extension ObservableType {
        /**
         Prints received events for all observers on colorized output.
         - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)

         - parameter identifier: Identifier that is printed together with event description to standard output.
         - returns: An observable sequence whose events are printed to standard output.
         */
        @warn_unused_result(message = "http://git.io/rxs.uo")
        func log(identifier: String? = nil, file: String = #file, line: UInt = #line, function: String = #function)
            -> Observable<E> {
                return Observable.create { observer in
                    let subscription = self.subscribe { e in
                        RxLogger.output(e, identifier: identifier, file: file, line: line, function: function)
                        switch e {
                        case .Next(let value):
                            observer.on(.Next(value))
                        case .Error(let error):
                            observer.on(.Error(error))
                        case .Completed:
                            observer.on(.Completed)
                        }
                    }

                    return subscription
                }
        }
    }

    public struct RxLogger<E> {

        public static func output(event: RxSwift.Event<E>, identifier: String?, file: String = #file, line: UInt = #line, function: String = #function) {

            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

            func format(value: String) -> String {
                return "\(dateFormat.stringFromDate(NSDate())): " + (file as NSString).lastPathComponent
                    + ":" + "\(line)" + " (\(function))" + " -> " + value
            }

            switch event {
            case .Next(let value):
                print(XcodeColor.darkGreen.format() + format("Event Next(\(value))") + XcodeColor.reset)
            case .Error(let error):
                print(XcodeColor.red.format() + format("Event Error(\(error))") + XcodeColor.reset)
            case .Completed:
                print(XcodeColor.darkGrey.format() + format("Event Completed") + XcodeColor.reset)
            }
        }
    }

    public struct XcodeColor {
        public static let escape = "\u{001b}["
        public static let resetFg = "\u{001b}[fg;"
        public static let resetBg = "\u{001b}[bg;"
        public static let reset = "\u{001b}[;"

        public var fg: (Int, Int, Int)? = nil
        public var bg: (Int, Int, Int)? = nil

        public func format() -> String {
            guard fg != nil || bg != nil else {
                // neither set, return reset value
                return XcodeColor.reset
            }

            var format: String = ""

            if let fg = fg {
                format += "\(XcodeColor.escape)fg\(fg.0),\(fg.1),\(fg.2);"
            }
            else {
                format += XcodeColor.resetFg
            }

            if let bg = bg {
                format += "\(XcodeColor.escape)bg\(bg.0),\(bg.1),\(bg.2);"
            }
            else {
                format += XcodeColor.resetBg
            }

            return format
        }

        public init(fg: (Int, Int, Int)? = nil, bg: (Int, Int, Int)? = nil) {
            self.fg = fg
            self.bg = bg
        }

        #if os(OSX)
            public init(fg: NSColor, bg: NSColor? = nil) {
                if let fgColorSpaceCorrected = fg.colorUsingColorSpaceName(NSCalibratedRGBColorSpace) {
                    self.fg = (Int(fgColorSpaceCorrected.redComponent * 255), Int(fgColorSpaceCorrected.greenComponent * 255), Int(fgColorSpaceCorrected.blueComponent * 255))
                }
                else {
                    self.fg = nil
                }

                if let bg = bg,
                    let bgColorSpaceCorrected = bg.colorUsingColorSpaceName(NSCalibratedRGBColorSpace) {

                        self.bg = (Int(bgColorSpaceCorrected.redComponent * 255), Int(bgColorSpaceCorrected.greenComponent * 255), Int(bgColorSpaceCorrected.blueComponent * 255))
                }
                else {
                    self.bg = nil
                }
            }
        #elseif os(iOS) || os(tvOS) || os(watchOS)
            public init(fg: UIColor, bg: UIColor? = nil) {
                var redComponent: CGFloat = 0
                var greenComponent: CGFloat = 0
                var blueComponent: CGFloat = 0
                var alphaComponent: CGFloat = 0

                fg.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
                self.fg = (Int(redComponent * 255), Int(greenComponent * 255), Int(blueComponent * 255))
                if let bg = bg {
                    bg.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
                    self.bg = (Int(redComponent * 255), Int(greenComponent * 255), Int(blueComponent * 255))
                }
                else {
                    self.bg = nil
                }
            }
        #endif

        public static let red: XcodeColor = {
            return XcodeColor(fg: (255, 0, 0))
        }()

        public static let darkGreen: XcodeColor = {
            return XcodeColor(fg: (0, 128, 0))
        }()

        public static let darkGrey: XcodeColor = {
            return XcodeColor(fg: (169, 169, 169))
        }()
    }
#else

    extension ObservableType {
        /**
         Prints received events for all observers on colorized output.
         - seealso: [do operator on reactivex.io](http://reactivex.io/documentation/operators/do.html)

         - parameter identifier: Identifier that is printed together with event description to standard output.
         - returns: An observable sequence whose events are printed to standard output.
         */
        @warn_unused_result(message = "http://git.io/rxs.uo")
        func log(@autoclosure identifier: () -> String?)
            -> Observable<E> {
                return self.asObservable()
        }
    }

#endif