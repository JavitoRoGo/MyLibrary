//
//  DateHelper.swift
//
//
//  Created by Javier Rodríguez Gómez on 21/8/23.
//
//  This file contains several functions and extensions to get it easier to handle with Date data type.

import Foundation

// Adding and substracting two DateComponents

public func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
	return addDateComponents(lhs, rhs)
}

public func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
	return addDateComponents(lhs, rhs, multiplier: -1)
}

func addDateComponents(_ lhs: DateComponents, _ rhs: DateComponents, multiplier: Int = 1) -> DateComponents {
	var result = DateComponents()
	
	result.nanosecond = (lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0) * multiplier
	result.second     = (lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier
	result.minute     = (lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier
	result.hour       = (lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier
	result.day        = (lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier
	result.weekOfYear = (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier
	result.month      = (lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier
	result.year       = (lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier
	
	return result
}

// Negation function used in substracting operations

public prefix func -(components: DateComponents) -> DateComponents {
	var result = DateComponents()
	
	if components.nanosecond != nil { result.nanosecond = -components.nanosecond! }
	if components.second     != nil { result.second     = -components.second! }
	if components.minute     != nil { result.minute     = -components.minute! }
	if components.hour       != nil { result.hour       = -components.hour! }
	if components.day        != nil { result.day        = -components.day! }
	if components.weekOfYear != nil { result.weekOfYear = -components.weekOfYear! }
	if components.month      != nil { result.month      = -components.month! }
	if components.year       != nil { result.year       = -components.year! }
	
	return result
}

// Adding DateComponents to Date, and Date to DateComponents with the first one

func +(_ lhs: Date, _ rhs: DateComponents) -> Date {
	return Calendar.current.date(byAdding: rhs, to: lhs)!
}

func +(_ lhs: DateComponents, _ rhs: Date) -> Date {
	return rhs + lhs
}

// Substracting Date and DateComponents

func -(_ lhs: Date, _ rhs: DateComponents) -> Date {
	return lhs + (-rhs)
}

// Creating a Date easily with DateComponents

extension Date {
	init(year: Int,
		 month: Int,
		 day: Int,
		 hour: Int = 0,
		 minute: Int = 0,
		 second: Int = 0,
		 timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		components.timeZone = timeZone
		self = Calendar.current.date(from: components)!
	}
	
	var desc: String {
		get {
			let PREFERRED_LOCALE = "en_US"
			return self.description(with: Locale(identifier: PREFERRED_LOCALE))
		}
	}
}

// Showing the difference between two Dates

public func -(_ lhs: Date, _ rhs: Date) -> DateComponents {
	return Calendar.current.dateComponents(
		[.year, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond],
		from: rhs,
		to: lhs)
}

// Creating easily DateComponents with Int

public extension Int {
	var seconds: DateComponents {
		var components = DateComponents()
		components.second = self
		return components
	}
	
	var minutes: DateComponents {
		var components = DateComponents()
		components.minute = self
		return components
	}
	
	var hours: DateComponents {
		var components = DateComponents()
		components.hour = self
		return components
	}
	
	var days: DateComponents {
		var components = DateComponents()
		components.day = self
		return components
	}
	
	var weeks: DateComponents {
		var components = DateComponents()
		components.weekOfYear = self
		return components
	}
	
	var months: DateComponents {
		var components = DateComponents()
		components.month = self
		return components
	}
	
	var years: DateComponents {
		var components = DateComponents()
		components.year = self
		return components
	}
}

// Showing the difference between actual Date and a given date

public extension DateComponents {
	var fromNow: Date {
		return Calendar.current.date(byAdding: self, to: Date())!
	}
	
	var ago: Date {
		return Calendar.current.date(byAdding: -self, to: Date())!
	}
}
