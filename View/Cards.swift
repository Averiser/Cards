//
//  Cards.swift
//  Cards
//
//  Created by MyMacBook on 25.07.2022.
//

import UIKit

protocol FlippableView: UIView {
  var isFlipped: Bool { get set }
  var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
  func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {

  var isFlipped: Bool = false {
    didSet {
      self.setNeedsDisplay()
    }
  }

  var flipCompletionHandler: ((FlippableView) -> Void)?

  func flip() {
    // определяем, между какими представлениями осуществить переход
    let fromView = isFlipped ? frontSideView : backSideView
    let toView = isFlipped ? backSideView : frontSideView
    // запускаем анимированный переход
    UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop], completion: { _ in
      // обработчик переворота
      self.flipCompletionHandler?(self)
    })
    isFlipped.toggle()
  }

  // card color
  var color:  UIColor!

  var cornerRadius = 20
  
  var startTouchPoint: CGPoint!
  
  // точка привязки
  private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // изменяем координаты точки привязки
    anchorPoint.x = touches.first!.location(in: window).x - frame.minX
    anchorPoint.y = touches.first!.location(in: window).y - frame.minY
    
    // сохраняем исходные координаты
    startTouchPoint = frame.origin
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
    frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    // анимировано возвращаем карточку в исходную позицию
//    UIView.animate(withDuration: 0.5) {
//      self.frame.origin = self.startTouchPoint
//
//      // переворачиваем представление
//      if self.transform.isIdentity {
//        self.transform = CGAffineTransform(rotationAngle: .pi)
//      } else {
//        self.transform = .identity
//      }
//    }
    if frame.origin == startTouchPoint {
      flip()
    }
    
  }
  

  init(frame: CGRect, color: UIColor) {
    super.init(frame: frame)
    self.color = color
    setupBorders()
  }

  override func draw(_ rect: CGRect) {
    // удаляем добавленные ранее дочерние представления
    backSideView.removeFromSuperview()
    frontSideView.removeFromSuperview()

    // добавляем новые представления
    if isFlipped {
      self.addSubview(backSideView)
      self.addSubview(frontSideView)
    } else {
      self.addSubview(frontSideView)
      self.addSubview(backSideView)
    }
  }

  private func setupBorders() {
    clipsToBounds = true
    layer.cornerRadius = CGFloat(cornerRadius)
    layer.borderWidth = 2
    layer.borderColor = UIColor.black.cgColor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // внутренний отступ представления
  private let margin: Int = 10

  // представление с лицевой стороной карты
  lazy var frontSideView: UIView = getFrontSideView()
  // представление с обратной стороной карты
  lazy var backSideView: UIView = self.getBackSideView()

  // возвращает представление для лицевой стороны карточки
  private func getFrontSideView() -> UIView {
    let view = UIView(frame: bounds)
    view.backgroundColor = .white

    let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(bounds.width)-margin*2, height: Int(bounds.height)-margin*2))
    view.addSubview(shapeView)

    // создание слоя с фигурой
    let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
    shapeView.layer.addSublayer(shapeLayer)
    
    // скругляем углы корневого слоя
    view.layer.masksToBounds = true
    view.layer.cornerRadius = CGFloat(cornerRadius)

    return view
  }

  // возвращает представление для обратной стороны карточки
  private func getBackSideView() -> UIView {
    let view = UIView(frame: bounds)
    view.backgroundColor = .white

    //выбор случайного узора для рубашки
    switch ["circle", "line"].randomElement()! {
    case "circle":
      let layer = BackSideCircle(size: bounds.size, fillColor: UIColor.black.cgColor)
      view.layer.addSublayer(layer)
    case "line":
      let layer = BackSideLine(size: bounds.size, fillColor: UIColor.black.cgColor)
      view.layer.addSublayer(layer)
    default:
      break
    }
    
    // скругляем углы корневого слоя
    view.layer.masksToBounds = true
    view.layer.cornerRadius = CGFloat(cornerRadius)

    return view
  }

}
