import JavaScriptKit

@JSFunction package func jsFunctionWithPackageAccess() throws(JSException)
@JSFunction public func jsFunctionWithPublicAccess() throws(JSException)
@JSFunction internal func jsFunctionWithInternalAccess() throws(JSException)
@JSFunction fileprivate func jsFunctionWithFilePrivateAccess() throws(JSException)
@JSFunction private func jsFunctionWithPrivateAccess() throws(JSException)
