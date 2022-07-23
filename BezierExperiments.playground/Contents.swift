//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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
  }
  
  private func getPath() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 50, y: 50))
    path.addLine(to: CGPoint(x: 150, y: 50))
    
    path.addLine(to: CGPoint(x: 150, y: 150))
    path.close()
    
    // создание второго треугольника
    path.move(to: CGPoint(x: 50, y: 70))
    path.addLine(to: CGPoint(x: 150, y: 170))
    path.addLine(to: CGPoint(x: 50, y: 170))
    path.close()
    
    
    
    return path
  }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
