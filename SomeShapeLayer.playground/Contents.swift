//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
  init(size: CGSize, fillColor: CGColor)
}

protocol FlippableView: UIView {
  var isFlipped: Bool { get set }
  var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
  func flip()
}

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    // рассчитываем данные для круга
    // радиус равен половине меньшей из сторон
    let radius = ([size.width, size.height].min() ?? 0) / 2
    // центр круга равен центрам каждой из сторон
    let centerX = size.width / 2
    let centerY = size.height / 2
    // draw a circle
    let path =  UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
    path.close()
    // инициализируем созданный путь
    self.path = path.cgPath
    // изменяем цвет
    self.fillColor = fillColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    // сторона равна меньшей из сторон
    let edgeSize = ([size.width, size.height].min() ?? 0)
    // draw a square
    let rect = CGRect(x: 100, y: 300, width: edgeSize, height: edgeSize)
    let path = UIBezierPath(rect: rect)
    self.path = path.cgPath
    self.fillColor = fillColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: size.width, y: size.height))
    path.move(to: CGPoint(x: size.width, y: 0))
    path.addLine(to: CGPoint(x: 0, y: size.height))
    
    self.path = path.cgPath
    self.strokeColor = fillColor
    lineWidth = 5
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    self.path = path.cgPath
    self.fillColor = fillColor
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    let path = UIBezierPath()
    
    // draw 15 circles
    for _ in 1...15 {
      // координаты центра очередного круга
      let randomX = Int.random(in: 0...Int(size.width))
      let randomY = Int.random(in: 0...Int(size.height))
      let center = CGPoint(x: randomX, y: randomY)
      // смещаем указатель к центру круга
      path.move(to: center)
      // определяем случайный радиус
      let radius = Int.random(in: 5...15)
      // draw a circle
      path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
    }
    // определяем случайный радиус
    self.path = path.cgPath
    self.strokeColor = fillColor
    self.fillColor = fillColor
    self.lineWidth = 1
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
  required init(size: CGSize, fillColor: CGColor) {
    super.init()
    
    let path = UIBezierPath()
    
    // draw 15 lines
    for _ in 1...15 {
      // координаты начала очередной линии
      let randomXStart = Int.random(in: 0...Int(size.width))
      let randomYStart = Int.random(in: 0...Int(size.height))
      // координаты конца очередной линии
      let randomXEnd = Int.random(in: 0...Int(size.width))
      let randomYEnd = Int.random(in: 0...Int(size.height))
      // смещаем указатель к началу линии
      path.move(to: CGPoint(x: randomXStart, y: randomYStart))
      path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
      
      self.path = path.cgPath
      self.strokeColor = fillColor
      self.fillColor = fillColor
      lineWidth = 3
      lineCap = .round
    }
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
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




class MyViewController : UIViewController {
  
    override func loadView() {
        let view = UIView()
      view.backgroundColor = .white
      self.view = view
      
      // circle
//      view.layer.addSublayer(CircleShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
      view.layer.addSublayer(SquareShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
//      view.layer.addSublayer(CrossShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.green.cgColor))
//      view.layer.addSublayer(FillShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.purple.cgColor ))
//      view.layer.addSublayer(BackSideCircle(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
//      view.layer.addSublayer(BackSideLine(size: CGSize(width: 200, height: 150), fillColor: UIColor.green.cgColor))
      
      // игральная карточка рубашкой вверх
      let firstCardView = CardView<CircleShape>(frame: CGRect(x: 0, y: 0, width: 120, height: 150), color: .red)
      firstCardView.flipCompletionHandler = { card in
        card.superview?.bringSubviewToFront(card)
      }
      self.view.addSubview(firstCardView)
      
      // игральная карточка лицевой стороной вверх
      let secondCardView = CardView<CircleShape>(frame: CGRect(x: 200, y: 0, width: 120, height: 150), color: .red)
      secondCardView.flipCompletionHandler = { card in
        card.superview?.bringSubviewToFront(card)
      }
      self.view.addSubview(secondCardView)
      secondCardView.isFlipped = true
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

extension ShapeLayerProtocol {
  init() {
    fatalError("init() cannot be used to create an instance")
  }
}

extension UIResponder {
  func responderChain() -> String {
    guard let next = next else {
      return String(describing: Self.self)
    }
    return String(describing: Self.self) + " -> " + next.responderChain()
  }
}
