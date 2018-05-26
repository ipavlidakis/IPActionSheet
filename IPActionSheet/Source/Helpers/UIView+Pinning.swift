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
    
    func activate() {
        
        NSLayoutConstraint.activate(Array(storage.values))
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
        case .width: return self.width
        case .height: return self.height
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

struct UIPinRelations {
    
    let left: NSLayoutRelation?
    let top: NSLayoutRelation?
    let right: NSLayoutRelation?
    let bottom: NSLayoutRelation?
    let width: NSLayoutRelation?
    let height: NSLayoutRelation?
    
    static let equalEdges: UIPinRelations = UIPinRelations(left: .equal, top: .equal, right: .equal, bottom: .equal, width: nil, height: nil)
    static let equalSizes: UIPinRelations = UIPinRelations(left: nil, top: nil, right: nil, bottom: nil, width: .equal, height: .equal)
    
    func value(for layoutAttribute: NSLayoutAttribute) -> NSLayoutRelation? {
        
        switch layoutAttribute {
        case .leading, .leadingMargin, .leftMargin: return left
        case .top, .topMargin: return top
        case .trailing, .trailingMargin: return right
        case .bottom, .bottomMargin: return bottom
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
        
        return NSLayoutConstraint(item: item,
                                  attribute: attribute,
                                  relatedBy: relatedBy,
                                  toItem: toItem,
                                  attribute: toItemAttribute ?? attribute,
                                  multiplier: multiplier,
                                  constant: constant)
    }
}

extension UIView {
    
    func pin(toEdges edges: [NSLayoutAttribute],
             toItem item: Any? = nil,
             relations: UIPinRelations,
             with valueProvider: UILayoutAttributeValueProviding) -> IPLayoutConfiguration {
        
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
        
        return IPLayoutConfiguration(storage: result)
    }
    
}

extension UIView {
    
    private func pinToSuperviewEdges(with insets: UIEdgeInsets,
                                     relations: UIPinRelations = .equalEdges) -> IPLayoutConfiguration? {
        
        guard let superview = superview else { return nil }
        
        return pin(toEdges: NSLayoutAttribute.allEdges,
                   toItem: superview,
                   relations: relations,
                   with: insets)
    }
    
    @discardableResult
    func pinToSuperviewEdges(with insets: UIEdgeInsets,
                             relations: UIPinRelations = .equalEdges,
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
                   with: insets)
    }
}

extension UIView {
    
    private func pin(sizeEdges: [NSLayoutAttribute],
                     with size: CGSize,
                     relations: UIPinRelations = .equalSizes) -> IPLayoutConfiguration? {
        
        guard translatesAutoresizingMaskIntoConstraints == false else {
            
            return nil
        }
        
        return pin(toEdges: sizeEdges,
                   relations: relations,
                   with: size)
    }
    
    private func pin(singleEdge edge: NSLayoutAttribute,
                     size: CGSize)  -> NSLayoutConstraint? {
        
        guard let result = pin(sizeEdges: [edge], with: size), let constraint = result[edge] else {
            
            return nil
        }
        
        return constraint
    }
    
    @discardableResult
    func pin(width: CGFloat,
             relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint? {
        
        return pin(singleEdge: .width, size: CGSize(width: width, height: 0))
    }
    
    @discardableResult
    func pin(height: CGFloat,
             relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint? {
        
        return pin(singleEdge: .height, size: CGSize(width: 0, height: height))
    }
    
    @discardableResult
    func pinSize(size: CGSize,
                 relations: UIPinRelations = .equalSizes) -> IPLayoutConfiguration? {
        
        return pin(sizeEdges: [.width, .height], with: size, relations: relations)
    }
}
