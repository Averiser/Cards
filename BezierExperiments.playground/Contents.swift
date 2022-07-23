//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import CoreGraphics

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
      
      createBezier(on: view)
    }
  
  private func createBezier(on view: UIView) {
    // 1
    // создаем графический контекст (слой)
    // на нем в дальнейшем будут рисоваться кривые
    let shapeLayer = CAShapeLayer()
    // 2
    // добавляем слой в качестве дочернего к корневому слою корневого представления
    view.layer.addSublayer(shapeLayer)
    
    // 2
    // изменение цвета линий
    shapeLayer.strokeColor = UIColor.gray.cgColor
    shapeLayer.lineWidth = 5
    
    // определение фонового цвета
    shapeLayer.fillColor = UIColor.green.cgColor
//    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineCap = .round
//    shapeLayer.lineDashPattern = [5, 2, 11]
//    shapeLayer.strokeStart = 0.3
//    shapeLayer.strokeEnd = 0.7
    shapeLayer.lineJoin = .round
    
    // 3
    // создание фигуры
    shapeLayer.path = getPath().cgPath
    shapeLayer.path = getPath2().cgPath
  }
  
  private func getPath() -> UIBezierPath {
//    let path = UIBezierPath()
//    path.move(to: CGPoint(x: 10, y: 10))
//    path.addLine(to: CGPoint(x: 210, y: 10))
//    path.addLine(to: CGPoint(x: 210, y: 110))
//    path.addLine(to: CGPoint(x: 10, y: 110))
//    path.close()
    
    // создание сущности «Прямоугольник»
    let rect = CGRect(x: 10, y: 10, width: 200, height: 100)
    // создание прямоугольника
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomRight, .topLeft], cornerRadii: CGSize(width: 30, height: 0))

    return path
  }
  
  private func getPath2() -> UIBezierPath {
    // arc
//    let centerPoint = CGPoint(x: 200, y: 200)
//    let path = UIBezierPath(arcCenter: centerPoint, radius: 150, startAngle: .pi/5, endAngle: .pi, clockwise: true)
    
    // circle
//    let path = UIBezierPath(arcCenter: centerPoint, radius: 150, startAngle: 0, endAngle: .pi*2, clockwise: true)
    
    // oval
//    let rect = CGRect(x: 50, y: 50, width: 200, height: 100)
//    let path = UIBezierPath(ovalIn: rect)
    
    // curve
    let path = UIBezierPath()
//    path.move(to: CGPoint(x: 10, y: 10))
//    path.addCurve(to: CGPoint(x: 200, y: 200), controlPoint1: CGPoint(x: 200, y: 20), controlPoint2: CGPoint(x: 20, y: 200))
    
    // chef's hat
    path.move(to: CGPoint(x: 100, y: 100))
    path.addArc(withCenter: CGPoint(x: 150, y: 100), radius: 50, startAngle: .pi, endAngle: 0, clockwise: true)
    path.addLine(to: CGPoint(x: 220, y: 100))
    path.addArc(withCenter: CGPoint(x: 220, y: 150), radius: 50, startAngle: .pi*3/2, endAngle: .pi/2, clockwise: true)
    path.addLine(to: CGPoint(x: 200, y: 200))
    path.addLine(to: CGPoint(x: 200, y: 260))
    path.addLine(to: CGPoint(x: 100, y: 260))
    path.addLine(to: CGPoint(x: 100, y: 200))
    path.addLine(to: CGPoint(x: 80, y: 200))
    path.addArc(withCenter: CGPoint(x: 80, y: 150), radius: 50, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: true)
    path.close()
    return path
  }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
