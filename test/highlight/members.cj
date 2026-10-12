// Token classes as cjls's semantic tokens give them: punctuation is not an
// operator, a member variable is a property, a member function a method.
package demo
import std.collection.*
//                   ^ @punctuation.delimiter
//                    ^ @punctuation.delimiter

public enum Shape { | Circle(Float64) | Square(Float64) | Empty }
//                ^ @punctuation.bracket
//                  ^ @punctuation.delimiter
//                    ^ @constant
//                          ^ @punctuation.bracket
//                                    ^ @punctuation.delimiter

public class Point {
    public static let ORIGIN = Point(0, 0)
//                    ^ @property
//                           ^ @operator
//                             ^ @function
//                                  ^ @punctuation.bracket
//                                    ^ @punctuation.delimiter
    private var count: Int64 = 0
//              ^ @property
//                   ^ @punctuation.delimiter
    public Point(let x: Int64, var y: Int64, z: Int64) {}
//         ^ @function.method
//                   ^ @property
//                                 ^ @property
//                                           ^ @parameter
    public func move(dx!: Int64): Point {
//              ^ @function.method
//                   ^ @parameter
        this.count += 1
//      ^ @variable.builtin
//          ^ @punctuation.delimiter
//           ^ @property
//                 ^ @operator
        Point(x + dx, y)
//      ^ @function
//              ^ @operator
    }
}

struct Box<T> {
//        ^ @punctuation.bracket
//         ^ @type
//          ^ @punctuation.bracket
    static func make(): Unit {}
//              ^ @function.method
}

extend Box<Int64> { func size(): Int64 { 0 } }
//        ^ @punctuation.bracket
//                       ^ @function.method

foreign { func cf(): Unit }
//             ^ @function

func area(s: Shape): Float64 {
//   ^ @function
//        ^ @parameter
//         ^ @punctuation.delimiter
    match (s) {
        case Circle(r) => 3.14 * r * r
//           ^ @constant
//                  ^ @variable
//                     ^ @operator
//                             ^ @operator
        case _ => 0.0
    }
}

main(): Int64 {
    let p = Point(1, 2)
//      ^ @variable
//          ^ @function
    let q = p.move(dx: 3)
//           ^ @punctuation.delimiter
//            ^ @function.method
//                ^ @punctuation.bracket
    let l = ArrayList<Int64>()
//          ^ @function
//                   ^ @punctuation.bracket
//                         ^ @punctuation.bracket
    l.add(1)
//    ^ @function.method
    l.map { x => x }
//    ^ @function.method
    let g = l.get<Int64>(0)
//            ^ @function.method
//               ^ @punctuation.bracket
    let s = Foo::create(1)
//             ^ @punctuation.delimiter
//               ^ @function.method
    let n = Int64(2.0)
//          ^ @type.builtin
    let c = p.x.y(1)
//            ^ @property
//              ^ @function.method
    let u = ()
//          ^ @constant.builtin
    let b = 1 < 2 || 3 > 2
//            ^ @operator
//                ^ @operator
//                     ^ @operator
    let r = 0..10
//           ^ @operator
    let a = [1, 2]
//          ^ @punctuation.bracket
//            ^ @punctuation.delimiter
    return 0
}
