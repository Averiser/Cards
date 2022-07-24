//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol: CAShapeLayer {
  init(size: CGSize, fillColor: CGColor)
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

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
      view.backgroundColor = .white
      self.view = view
      
      // circle
      view.layer.addSublayer(CircleShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
      view.layer.addSublayer(SquareShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
      view.layer.addSublayer(CrossShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.green.cgColor))
      view.layer.addSublayer(FillShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.purple.cgColor ))
      view.layer.addSublayer(BackSideCircle(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
      view.layer.addSublayer(BackSideLine(size: CGSize(width: 200, height: 150), fillColor: UIColor.green.cgColor))
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

extension ShapeLayerProtocol {
  init() {
    fatalError("init() cannot be used to create an instance")
  }
}
