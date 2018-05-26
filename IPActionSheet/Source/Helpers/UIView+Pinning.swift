//
//  UIView-Pinning.swift
//  IPActionSheet
//
//  Created by Ilias Pavlidakis on 26/05/2018.
//  Copyright © 2018 Ilias Pavlidakis. All rights reserved.
//

import UIKit

struct IPLayoutConfiguration {
    
    let storage: [NSLayoutAttribute: NSLayoutConstraint]
    let priorities: UIPinPriorities
    
    @discardableResult
    func applyPriorities() -> IPLayoutConfiguration {
        
        storage.forEach {
            
            guard let priority = priorities.value(for: $0.0) else { return }
            
            $0.1.priority = priority
        }
        
        return self
    }
    
    @discardableResult
    func activate() -> IPLayoutConfiguration {
        
        NSLayoutConstraint.activate(Array(storage.values))
        
        return self
    }
    
    @discardableResult
    func deactivate() -> IPLayoutConfiguration {
        
        NSLayoutConstraint.deactivate(Array(storage.values))
        
        return self
    }
    
    subscript(index: NSLayoutAttribute) -> NSLayoutConstraint? {
        
        return storage[index]
    }
}

protocol UILayoutAttributeValueProviding {
    
    func value(for layoutAttribute: NSLayoutAttribute) -> CGFloat
}

extension CGSize: UILayoutAttributeValueProviding {
    
    func value(for layoutAttribute: NSLayoutAttribute) -> CGFloat {
        
        switch layoutAttribute {
        case .width: return width
        case .height: return height
        default: return 0
        }
    }
}

extension CGPoint: UILayoutAttributeValueProviding {
    
    func value(for layoutAttribute: NSLayoutAttribute) -> CGFloat {
        
        switch layoutAttribute {
        case .centerX: return x
        case .centerY: return y
        default: return 0
        }
    }
}


extension NSLayoutAttribute {
    
    static let allEdges: [NSLayoutAttribute] = [.leading, .top, .trailing, .bottom]
}

extension UIEdgeInsets: UILayoutAttributeValueProviding {
    
    func value(for layoutAttribute: NSLayoutAttribute) -> CGFloat {
        
        switch layoutAttribute {
        case .leading, .leadingMargin, .leftMargin: return left
        case .top, .topMargin: return top
        case .trailing, .trailingMargin: return right
        case .bottom, .bottomMargin: return bottom
        default: return 0
        }
    }
}

final class UIPinRelations {
    
    let left: NSLayoutRelation?
    let top: NSLayoutRelation?
    let right: NSLayoutRelation?
    let bottom: NSLayoutRelation?
    let width: NSLayoutRelation?
    let height: NSLayoutRelation?
    let centerY: NSLayoutRelation?
    let centerX: NSLayoutRelation?
    
    init(left: NSLayoutRelation? = nil,
         top: NSLayoutRelation? = nil,
         right: NSLayoutRelation? = nil,
         bottom: NSLayoutRelation? = nil,
         width: NSLayoutRelation? = nil,
         height: NSLayoutRelation? = nil,
         centerY: NSLayoutRelation? = nil,
         centerX: NSLayoutRelation? = nil) {
        
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
        self.width = width
        self.height = height
        self.centerY = centerY
        self.centerX = centerX
    }
    
    static let equalEdges: UIPinRelations = UIPinRelations(left: .equal, top: .equal, right: .equal, bottom: .equal)
    static let equalSizes: UIPinRelations = UIPinRelations(width: .equal, height: .equal)
    static let equalCenters: UIPinRelations = UIPinRelations(centerY: .equal, centerX: .equal)
    
    func value(for layoutAttribute: NSLayoutAttribute) -> NSLayoutRelation? {
        
        switch layoutAttribute {
        case .leading, .leadingMargin, .leftMargin: return left
        case .top, .topMargin: return top
        case .trailing, .trailingMargin: return right
        case .bottom, .bottomMargin: return bottom
        case .height: return height
        case .width: return width
        case .centerY: return centerY
        case .centerX: return centerX
        default: return nil
        }
    }
}

final class UIPinPriorities {
    
    let left: UILayoutPriority?
    let top: UILayoutPriority?
    let right: UILayoutPriority?
    let bottom: UILayoutPriority?
    let width: UILayoutPriority?
    let height: UILayoutPriority?
    let centerY: UILayoutPriority?
    let centerX: UILayoutPriority?
    
    init(left: UILayoutPriority = .required,
         top: UILayoutPriority? = .required,
         right: UILayoutPriority? = .required,
         bottom: UILayoutPriority? = .required,
         width: UILayoutPriority? = .required,
         height: UILayoutPriority? = .required,
         centerY: UILayoutPriority? = .required,
         centerX: UILayoutPriority? = .required) {
        
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
        self.width = width
        self.height = height
        self.centerY = centerY
        self.centerX = centerX
    }
    
    func value(for layoutAttribute: NSLayoutAttribute) -> UILayoutPriority? {
        
        switch layoutAttribute {
        case .leading, .leadingMargin, .leftMargin: return left
        case .top, .topMargin: return top
        case .trailing, .trailingMargin: return right
        case .bottom, .bottomMargin: return bottom
        case .height: return height
        case .width: return width
        case .centerY: return centerY
        case .centerX: return centerX
        default: return nil
        }
    }
}

private extension UIView {
    
    func pin(item: Any,
             attribute: NSLayoutAttribute,
             relatedBy: NSLayoutRelation = .equal,
             toItem: Any? = nil,
             attribute toItemAttribute: NSLayoutAttribute? = nil,
             multiplier: CGFloat = 1,
             constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let toAttribute: NSLayoutAttribute
        
        if toItemAttribute == nil, [NSLayoutAttribute.height, .width].contains(attribute) {
            
            toAttribute = .notAnAttribute
        } else {
            
            toAttribute = attribute
        }
        
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: relatedBy,
                                  toItem: toItem,
                                  attribute: toAttribute,
                                  multiplier: multiplier,
                                  constant: constant)
    }
}

extension UIView {
    
    func pin(toEdges edges: [NSLayoutAttribute],
             toItem item: Any? = nil,
             relations: UIPinRelations,
             with valueProvider: UILayoutAttributeValueProviding,
             priorities: UIPinPriorities) -> IPLayoutConfiguration {
        
        let result = edges.reduce([NSLayoutAttribute: NSLayoutConstraint](), { ( result, layoutAttribute) -> [NSLayoutAttribute: NSLayoutConstraint] in
            
            guard let relatedBy = relations.value(for: layoutAttribute) else {
                
                return result
            }
            
            var result = result
            result[layoutAttribute] = pin(item: self,
                                          attribute: layoutAttribute,
                                          relatedBy: relatedBy,
                                          toItem: item,
                                          constant: valueProvider.value(for: layoutAttribute))
            return result
        })
        
        return IPLayoutConfiguration(storage: result, priorities: priorities).applyPriorities()
    }
    
}

extension UIView {
    
    private func pinToSuperviewEdges(with insets: UIEdgeInsets,
                                     relations: UIPinRelations = .equalEdges,
                                     priorities: UIPinPriorities) -> IPLayoutConfiguration? {
        
        guard let superview = superview else { return nil }
        
        return pin(toEdges: NSLayoutAttribute.allEdges,
                   toItem: superview,
                   relations: relations,
                   with: insets,
                   priorities: priorities)
    }
    
    @discardableResult
    func pinToSuperviewEdges(with insets: UIEdgeInsets,
                             relations: UIPinRelations = .equalEdges,
                             priorities: UIPinPriorities = UIPinPriorities(),
                             useSafeArea: Bool = true) -> IPLayoutConfiguration? {
        
        guard translatesAutoresizingMaskIntoConstraints == false,
            let superview = superview else {
                
                return nil
        }
        
        guard #available(iOS 11, *), useSafeArea else {
            
            return pinToSuperviewEdges(with: insets,
                                       relations: relations)
        }
        
        return pin(toEdges: NSLayoutAttribute.allEdges,
                   toItem: superview.safeAreaLayoutGuide,
                   relations: relations,
                   with: insets,
                   priorities: priorities)
    }
}

extension UIView {
    
    private func pin(sizeEdges: [NSLayoutAttribute],
                     with size: CGSize,
                     relations: UIPinRelations = .equalSizes,
                     priorities: UIPinPriorities) -> IPLayoutConfiguration? {
        
        guard translatesAutoresizingMaskIntoConstraints == false else {
            
            return nil
        }
        
        return pin(toEdges: sizeEdges,
                   relations: relations,
                   with: size,
                   priorities: priorities)
    }
    
    private func pin(singleEdge edge: NSLayoutAttribute,
                     size: CGSize,
                     priorities: UIPinPriorities)  -> IPLayoutConfiguration? {
        
        guard let result = pin(sizeEdges: [edge], with: size, priorities: priorities), let _ = result[edge] else {
            
            return nil
        }
        
        return result
    }
    
    @discardableResult
    func pin(width: CGFloat,
             relatedBy: NSLayoutRelation = .equal,
             priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pin(singleEdge: .width, size: CGSize(width: width, height: 0), priorities: priorities)
    }
    
    @discardableResult
    func pin(height: CGFloat,
             relatedBy: NSLayoutRelation = .equal,
             priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pin(singleEdge: .height, size: CGSize(width: 0, height: height), priorities: priorities)
    }
    
    @discardableResult
    func pinSize(size: CGSize,
                 relations: UIPinRelations = .equalSizes,
                 priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pin(sizeEdges: [.width, .height], with: size, relations: relations, priorities: priorities)
    }
}

extension UIView {
    
    private func pinAxis(toEdges: [NSLayoutAttribute],
                         with point: CGPoint,
                         relations: UIPinRelations,
                         priorities: UIPinPriorities) -> IPLayoutConfiguration? {
        
        guard translatesAutoresizingMaskIntoConstraints == false,
            let superview = superview else {
                
                return nil
        }
        
        return pin(toEdges: toEdges,
                   toItem: superview,
                   relations: relations,
                   with: point,
                   priorities: priorities)
    }
    
    @discardableResult
    func pinCenterOnVerticalAxis(constant: CGFloat = 0,
                                 relations: UIPinRelations = .equalCenters,
                                 priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pinAxis(toEdges: [.centerY], with: CGPoint(x: 0, y: constant), relations: relations, priorities: priorities)
    }
    
    @discardableResult
    func pinCenterOnHorizontalAxis(constant: CGFloat = 0,
                                   relations: UIPinRelations = .equalCenters,
                                   priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pinAxis(toEdges: [.centerX], with: CGPoint(x: constant, y: 0), relations: relations, priorities: priorities)
    }
    
    @discardableResult
    func pinCenterOnBothAxis(point: CGPoint,
                             relations: UIPinRelations = .equalCenters,
                             priorities: UIPinPriorities = UIPinPriorities()) -> IPLayoutConfiguration? {
        
        return pinAxis(toEdges: [.centerX, .centerY], with: point, relations: relations, priorities: priorities)
    }
}
