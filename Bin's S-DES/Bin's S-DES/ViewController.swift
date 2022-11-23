//
//  ViewController.swift
//  Bin's S-DES
//
//  Created by 조성빈 on 2022/11/11.
//

import UIKit

class ViewController: UIViewController {
    
    //변수들 선언
    @IBOutlet weak var enterkeyTF: UITextField!
    @IBOutlet weak var enteripTF: UITextField!
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var subkey1LB: UILabel!
    @IBOutlet weak var subkey2LB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        subkey1LB.text = nil
        subkey2LB.text = nil

        
    }
    
    //입력받은 10진수 키 값 -> 2진수로 변경 = String
    func numkeydigit() -> String {
        let enterkey1 : Int = Int(enterkeyTF.text!)!
        let enterkeybit : String = String(enterkey1,radix: 2)
        
        return enterkeybit
    }
   
    //변경된 2진수를 총 10비트로 만드는 함수. (빈자리를 앞에서부터 0으로 채움)
    func digit0() -> String {
        let digit10 = numkeydigit()
        var digit10AR = digit10.map{String($0)}
        let count = 10 - digit10AR.count
        for _ in 0...count {
            if digit10AR.count < 10 {
                digit10AR.insert("0", at: 0)
            }
        }
        let digit10a = digit10AR.joined(separator: " ")
        return digit10a
    }
    
    //10비트로 만든걸 p10을 이용해서 재배치하는 함수.
    func digitP10() -> String {
        let p10Key : [Int] = [3, 5, 2, 7, 4, 10, 1, 9, 8, 6]
        let digitAR = digit0().components(separatedBy: " ")
        var p10KeyResult1 : [String] = []
        for i in 0..<p10Key.count {
            p10KeyResult1.append(digitAR[p10Key[i]-1])
        }
        let p10KeyResult = p10KeyResult1.joined(separator: " ")
        return p10KeyResult
    }
    
    //재배치한 p10을 5비트씩 나누고 leftshift까지 완료하는 함수. LS1L, LS1R
    func LS1LR() -> (LS1L: Array<Any>, LS1R: Array<Any>) {
        let p10KeyResultArr = digitP10().components(separatedBy: " ")
        var LS1L : [String] = []
        var LS1R : [String] = []
        for i in 0..<5 {
            LS1L.append(p10KeyResultArr[i])
        }
        for i in 5..<10 {
            LS1R.append(p10KeyResultArr[i])
        }
        
        var temp = LS1L[0]
        LS1L[0]=LS1L[1]
        LS1L[1]=LS1L[2]
        LS1L[2]=LS1L[3]
        LS1L[3]=LS1L[4]
        LS1L[4]=temp
        
        temp = LS1R[0]
        LS1R[0]=LS1R[1]
        LS1R[1]=LS1R[2]
        LS1R[2]=LS1R[3]
        LS1R[3]=LS1R[4]
        LS1R[4]=temp
        
        return (LS1L, LS1R)
    }
    
    //P8와 LS1L,R 이용해서 K1 만드는 함수.
    func digitP8K1() -> String {
        let p8Key : [Int] = [6,3,7,4,8,5,10,9]
        var LS1 = LS1LR().LS1L + LS1LR().LS1R
        LS1.remove(at: 0)
        LS1.remove(at: 0)
        var newP8Key1 : [String] = []
        for i in 0..<p8Key.count {
            newP8Key1.append(LS1[p8Key[i]-3] as! String)
        }
        let newP8K1 = newP8Key1.joined(separator: "")
        return newP8K1
    }
    
    //K2 만드는 함수.
    func digitP8K2() -> String {
        let p8Key : [Int] = [6,3,7,4,8,5,10,9]
        var LS2L = LS1LR().LS1L
        var LS2R = LS1LR().LS1R
        //LS2L leftshift 2번
        var temp = LS2L[0]
        LS2L[0]=LS2L[1]
        LS2L[1]=LS2L[2]
        LS2L[2]=LS2L[3]
        LS2L[3]=LS2L[4]
        LS2L[4]=temp
            temp = LS2L[0]
        LS2L[0]=LS2L[1]
        LS2L[1]=LS2L[2]
        LS2L[2]=LS2L[3]
        LS2L[3]=LS2L[4]
        LS2L[4]=temp
        
        //LS2R leftshift 2번
        temp = LS2R[0]
        LS2R[0]=LS2R[1]
        LS2R[1]=LS2R[2]
        LS2R[2]=LS2R[3]
        LS2R[3]=LS2R[4]
        LS2R[4]=temp
        temp = LS2R[0]
        LS2R[0]=LS2R[1]
        LS2R[1]=LS2R[2]
        LS2R[2]=LS2R[3]
        LS2R[3]=LS2R[4]
        LS2R[4]=temp
        
        var LS2 = LS2L + LS2R
        LS2.remove(at: 0)
        LS2.remove(at: 0)
        var newP8Key2 : [String] = []
        for i in 0..<p8Key.count {
            newP8Key2.append(LS2[p8Key[i]-3] as! String)
        }
        let newP8K2 = newP8Key2.joined(separator: "")
        return newP8K2
    }
    
    //평문 IP작업후 8비트, 왼쪽 오른쪽 각 4비트 배열.
    func sentence() -> Array<String> {
        let IPkey = [2,6,3,1,4,8,5,7]
        let temp1 : String = enteripTF.text!
        let temp2 = temp1.map{String($0)}
        var str : String = ""
        var temp5 : [String] = [] // IP작업한 8비트
        
       
        for i in 0..<temp2.count {
            var temp3 = String(Int(UnicodeScalar(temp2[i])!.value),radix: 2)
            if temp3.count < 8 {
                temp3 = String(repeating: "0", count: 8-temp3.count) + temp3
                let temp4 = temp3.map{String($0)}
                for j in 0..<temp4.count {
                    str = str + temp4[IPkey[j]-1]
                    if j == temp4.count - 1 {
                        temp5.append(str)
                        str = ""
                        
                    }
                }
            }
        }
        return temp5
    }
    
    //IP작업한 오른쪽 4비트를 E/P 작업하는 것과 IP작업한 후의 왼쪽, 오른쪽 4비트 반환
    func IP_LR() -> (EP8bit: Array<String>, IPleft4: Array<String>, IPright4: Array<String>) {
        let EpKey = [4,1,2,3,2,3,4,1]
        let ip8bit = sentence()
        var IPleft4 : [String] = [] // IP작업후 왼쪽 4비트
        var IPright4 : [String] = [] // IP작업후 오른쪽 4비트
        var EP8bit : [String] = [] // IP작업한 오른쪽 4비트로 EP작업한 8비트
        var str1 : String = ""
        
        for i in 0..<ip8bit.count{
            var temp6 = ip8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp6[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp6.removeFirst()
                    }
                    let temp7 = temp6.joined(separator: "")
                    IPright4.append(temp7)
                }
            }
            IPleft4.append(left.joined(separator: ""))
            
            for k in 0..<EpKey.count {
                let temp8 = temp6[EpKey[k]-1]
                str1 = str1 + temp8
                if k == EpKey.count - 1 {
                    EP8bit.append(str1)
                    str1 = ""
                }
            }
        }
        return (EP8bit, IPleft4, IPright4)
    }
    
    //EP작업후 오른쪽4비트와 왼쪽4비트
    func EP_xor() -> (XorK1_8bit: Array<String>, S0_4bit: Array<String>, S1_4bit: Array<String>) {
        let subkey1 = digitP8K1().map{String($0)}
        let EP8bit = IP_LR().EP8bit
        var XorK1_8bit : [String] = [] //EP작업후 키1과 xor연산 8비트
        var str : String = ""
        var S0_4bit : [String] = [] // 왼쪽 4비트
        var S1_4bit : [String] = [] // 오른쪽 4비트
        
        for i in 0..<EP8bit.count {
            let temp1 = EP8bit[i].map{String($0)}
            for j in 0..<subkey1.count {
                if temp1[j] == subkey1[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            XorK1_8bit.append(str)
            str = ""
        }
        
        for i in 0..<XorK1_8bit.count{
            var temp2 = XorK1_8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp2[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp2.removeFirst()
                    }
                    let temp3 = temp2.joined(separator: "")
                    S1_4bit.append(temp3)
                }
            }
            S0_4bit.append(left.joined(separator: ""))
        }
        return (XorK1_8bit, S0_4bit, S1_4bit)
    }
    
    //S0, S1 작업후 합친 4비트
    func S01_func() -> (S01_4bit: Array<String>, P4_4bit: Array<String>) {
        let P4 = [2,4,3,1]
        let s0_4 = EP_xor().S0_4bit
        let s1_4 = EP_xor().S1_4bit
        let S0_4bit = S0_func(with: s0_4)
        let S1_4bit = S1_func(with: s1_4)
        var S01_4bit : [String] = []
        var str = ""
        var P4_4bit : [String] = []
        for i in 0..<s0_4.count {
            S01_4bit.append((S0_4bit[i] + S1_4bit[i]))
        }
//        return S01_4bit
        for i in 0..<S01_4bit.count {
            let temp = S01_4bit[i].map{String($0)}
            for j in 0..<P4.count {
                str = str + temp[P4[j]-1]
                if j == P4.count - 1 {
                    P4_4bit.append(str)
                    str = ""
                }
            }
        }
        return (S01_4bit, P4_4bit)
    }
    
    //P4작업한 4비트(S01_func().P4_4bit)와 sentence().IPleft4 비트의 xor연산.
    func P4_xor() -> (P4_XOR: Array<String>, SW_8bit: Array<String>) {
        let P4_4bit = S01_func().P4_4bit
        let IPleft4 = IP_LR().IPleft4
        var str = ""
        var P4_XOR : [String] = []
        
        for i in 0..<IPleft4.count {
            let temp1 = P4_4bit[i].map{String($0)}
            let temp2 = IPleft4[i].map{String($0)}
            for j in 0..<temp2.count {
                if temp1[j] == temp2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            P4_XOR.append(str)
            str = ""
        }
        let IPright4 = IP_LR().IPright4
        var SW_8bit : [String] = []
        for i in 0..<IPright4.count {
            let temp3 = IPright4[i] + P4_XOR[i]
            SW_8bit.append(temp3)
        }
        
        return (P4_XOR, SW_8bit)
    }
    
    func IP_LR1() -> (EP8bit: Array<String>, SWleft4: Array<String>, SWright4: Array<String>) {
        let EpKey = [4,1,2,3,2,3,4,1]
        let SW8bit = P4_xor().SW_8bit   //P4_xor().SW_8bit
        var SWleft4 : [String] = [] // IP작업후 왼쪽 4비트
        var SWright4 : [String] = [] // IP작업후 오른쪽 4비트
        var EP8bit : [String] = [] // IP작업한 오른쪽 4비트로 EP작업한 8비트
        var str1 : String = ""
        
        for i in 0..<SW8bit.count{
            var temp6 = SW8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp6[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp6.removeFirst()
                    }
                    let temp7 = temp6.joined(separator: "")
                    SWright4.append(temp7)
                }
            }
            SWleft4.append(left.joined(separator: ""))
            
            for k in 0..<EpKey.count {
                let temp8 = temp6[EpKey[k]-1]
                str1 = str1 + temp8
                if k == EpKey.count - 1 {
                    EP8bit.append(str1)
                    str1 = ""
                }
            }
        }
        return (EP8bit, SWleft4, SWright4)
    }
    
    func EP_xor2() -> (XorK2_8bit: Array<String>, S0_4bit: Array<String>, S1_4bit: Array<String>) {
        let subkey2 = digitP8K2().map{String($0)}
        let EP8bit = IP_LR1().EP8bit
        var XorK2_8bit : [String] = [] //EP작업후 키1과 xor연산 8비트
        var str : String = ""
        var S0_4bit : [String] = [] // 왼쪽 4비트
        var S1_4bit : [String] = [] // 오른쪽 4비트
        
        for i in 0..<EP8bit.count {
            let temp1 = EP8bit[i].map{String($0)}
            for j in 0..<subkey2.count {
                if temp1[j] == subkey2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            XorK2_8bit.append(str)
            str = ""
        }
        
        for i in 0..<XorK2_8bit.count{
            var temp2 = XorK2_8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp2[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp2.removeFirst()
                    }
                    let temp3 = temp2.joined(separator: "")
                    S1_4bit.append(temp3)
                }
            }
            S0_4bit.append(left.joined(separator: ""))
        }
        return (XorK2_8bit, S0_4bit, S1_4bit)
    }
    
    //S0, S1 작업후 합친 4비트
    func S01_func1() -> (S01_4bit: Array<String>, P4_4bit: Array<String>) {
        let P4 = [2,4,3,1]
        let s0_4 = EP_xor2().S0_4bit
        let s1_4 = EP_xor2().S1_4bit
        let S0_4bit = S0_func(with: s0_4)
        let S1_4bit = S1_func(with: s1_4)
        var S01_4bit : [String] = []
        var str = ""
        var P4_4bit : [String] = []
        for i in 0..<s0_4.count {
            S01_4bit.append((S0_4bit[i] + S1_4bit[i]))
        }
    //        return S01_4bit
        for i in 0..<S01_4bit.count {
            let temp = S01_4bit[i].map{String($0)}
            for j in 0..<P4.count {
                str = str + temp[P4[j]-1]
                if j == P4.count - 1 {
                    P4_4bit.append(str)
                    str = ""
                }
            }
        }
        return (S01_4bit, P4_4bit)
    }
    
    //P4작업한 4비트(S01_func1().P4_4bit)
    func P4_xor1() -> Array<String> {
        let P4_4bit = S01_func1().P4_4bit
        let SWleft4 = IP_LR1().SWleft4
        var str = ""
        var P4_XOR : [String] = []
        
        for i in 0..<SWleft4.count {
            let temp1 = P4_4bit[i].map{String($0)}
            let temp2 = SWleft4[i].map{String($0)}
            for j in 0..<temp2.count {
                if temp1[j] == temp2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            P4_XOR.append(str)
            str = ""
            
        }
        return P4_XOR
    }

    func IP_1() -> (str: String, result8bit: Array<String>) {
        let IP_1Key = [4,1,3,5,7,2,8,6]
        let left4 = P4_xor1()
        let right4 = P4_xor().P4_XOR
        var bit8 : [String] = []
        var str : String = ""
        var str1 = ""
        var result8bit : [String] = []
        
        for i in 0..<left4.count {
            bit8.append((left4[i] + right4[i]))
        }
        
        for i in 0..<bit8.count {
            let temp3 = bit8[i].map{String($0)}
            for j in 0..<IP_1Key.count {
                str1 = str1 + temp3[IP_1Key[j]-1]
                if j == IP_1Key.count - 1 {
                    result8bit.append(str1)
                    str1 = ""
                }
            }
        }
        
        for i in 0..<result8bit.count {
            let temp = Int(result8bit[i],radix: 2)!
            let temp1 = String(Unicode.Scalar(temp)!)
            str = str + temp1
        }
        return (str, result8bit)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //복호화
    
    //평문 IP작업후 8비트, 왼쪽 오른쪽 각 4비트 배열.
    func back_sentence() -> Array<String> {
        let IPkey = [2,6,3,1,4,8,5,7]
        let temp1 = IP_1().result8bit
        let temp2 = temp1.map{String($0)}
        var str : String = ""
        var temp5 : [String] = [] // IP작업한 8비트
        
        for i in 0..<temp1.count {
            var temp3 = temp1[i].map{String($0)}
            for j in 0..<IPkey.count {
                str = str + temp3[IPkey[j]-1]
                if j == IPkey.count - 1 {
                    temp5.append(str)
                    str = ""
                }
            }
        }
       
//        for i in 0..<temp2.count {
//            var temp3 = String(Int(UnicodeScalar(temp2[i])!.value),radix: 2)
//            if temp3.count < 8 {
//                temp3 = String(repeating: "0", count: 8-temp3.count) + temp3
//                let temp4 = temp3.map{String($0)}
//                for j in 0..<temp4.count {
//                    str = str + temp4[IPkey[j]-1]
//                    if j == temp4.count - 1 {
//                        temp5.append(str)
//                        str = ""
//
//                    }
//                }
//            }
//        }
        return temp5
    }
    
    
    func back_IP_LR() -> (EP8bit: Array<String>, IPleft4: Array<String>, IPright4: Array<String>) {
        let EpKey = [4,1,2,3,2,3,4,1]
        let ip8bit = back_sentence()
        var IPleft4 : [String] = [] // IP작업후 왼쪽 4비트
        var IPright4 : [String] = [] // IP작업후 오른쪽 4비트
        var EP8bit : [String] = [] // IP작업한 오른쪽 4비트로 EP작업한 8비트
        var str1 : String = ""
        
        for i in 0..<ip8bit.count{
            var temp6 = ip8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp6[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp6.removeFirst()
                    }
                    let temp7 = temp6.joined(separator: "")
                    IPright4.append(temp7)
                }
            }
            IPleft4.append(left.joined(separator: ""))
            
            for k in 0..<EpKey.count {
                let temp8 = temp6[EpKey[k]-1]
                str1 = str1 + temp8
                if k == EpKey.count - 1 {
                    EP8bit.append(str1)
                    str1 = ""
                }
            }
        }
        return (EP8bit, IPleft4, IPright4)
    }
    
    //EP작업후 오른쪽4비트와 왼쪽4비트
    func back_EP_xor() -> (XorK1_8bit: Array<String>, S0_4bit: Array<String>, S1_4bit: Array<String>) {
        let subkey2 = digitP8K2().map{String($0)}
        let EP8bit = back_IP_LR().EP8bit
        var XorK1_8bit : [String] = [] //EP작업후 키1과 xor연산 8비트
        var str : String = ""
        var S0_4bit : [String] = [] // 왼쪽 4비트
        var S1_4bit : [String] = [] // 오른쪽 4비트
        
        for i in 0..<EP8bit.count {
            let temp1 = EP8bit[i].map{String($0)}
            for j in 0..<subkey2.count {
                if temp1[j] == subkey2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            XorK1_8bit.append(str)
            str = ""
        }
        
        for i in 0..<XorK1_8bit.count{
            var temp2 = XorK1_8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp2[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp2.removeFirst()
                    }
                    let temp3 = temp2.joined(separator: "")
                    S1_4bit.append(temp3)
                }
            }
            S0_4bit.append(left.joined(separator: ""))
        }
        return (XorK1_8bit, S0_4bit, S1_4bit)
    }
    
    //S0, S1 작업후 합친 4비트
    func back_S01_func() -> (S01_4bit: Array<String>, P4_4bit: Array<String>) {
        let P4 = [2,4,3,1]
        let s0_4 = back_EP_xor().S0_4bit
        let s1_4 = back_EP_xor().S1_4bit
        let S0_4bit = S0_func(with: s0_4)
        let S1_4bit = S1_func(with: s1_4)
        var S01_4bit : [String] = []
        var str = ""
        var P4_4bit : [String] = []
        for i in 0..<s0_4.count {
            S01_4bit.append((S0_4bit[i] + S1_4bit[i]))
        }
//        return S01_4bit
        for i in 0..<S01_4bit.count {
            let temp = S01_4bit[i].map{String($0)}
            for j in 0..<P4.count {
                str = str + temp[P4[j]-1]
                if j == P4.count - 1 {
                    P4_4bit.append(str)
                    str = ""
                }
            }
        }
        return (S01_4bit, P4_4bit)
    }
    
    //P4작업한 4비트(S01_func().P4_4bit)와 sentence().IPleft4 비트의 xor연산.
    func back_P4_xor() -> (P4_XOR: Array<String>, SW_8bit: Array<String>) {
        let P4_4bit = back_S01_func().P4_4bit
        let IPleft4 = back_IP_LR().IPleft4
        var str = ""
        var P4_XOR : [String] = []
        
        for i in 0..<IPleft4.count {
            let temp1 = P4_4bit[i].map{String($0)}
            let temp2 = IPleft4[i].map{String($0)}
            for j in 0..<temp2.count {
                if temp1[j] == temp2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            P4_XOR.append(str)
            str = ""
        }
        let IPright4 = back_IP_LR().IPright4
        var SW_8bit : [String] = []
        for i in 0..<IPright4.count {
            let temp3 = IPright4[i] + P4_XOR[i]
            SW_8bit.append(temp3)
        }
        
        return (P4_XOR, SW_8bit)
    }
    
    func back_IP_LR1() -> (EP8bit: Array<String>, SWleft4: Array<String>, SWright4: Array<String>) {
        let EpKey = [4,1,2,3,2,3,4,1]
        let SW8bit = back_P4_xor().SW_8bit   //P4_xor().SW_8bit
        var SWleft4 : [String] = [] // IP작업후 왼쪽 4비트
        var SWright4 : [String] = [] // IP작업후 오른쪽 4비트
        var EP8bit : [String] = [] // IP작업한 오른쪽 4비트로 EP작업한 8비트
        var str1 : String = ""
        
        for i in 0..<SW8bit.count{
            var temp6 = SW8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp6[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp6.removeFirst()
                    }
                    let temp7 = temp6.joined(separator: "")
                    SWright4.append(temp7)
                }
            }
            SWleft4.append(left.joined(separator: ""))
            
            for k in 0..<EpKey.count {
                let temp8 = temp6[EpKey[k]-1]
                str1 = str1 + temp8
                if k == EpKey.count - 1 {
                    EP8bit.append(str1)
                    str1 = ""
                }
            }
        }
        return (EP8bit, SWleft4, SWright4)
    }
    
    func back_EP_xor2() -> (XorK2_8bit: Array<String>, S0_4bit: Array<String>, S1_4bit: Array<String>) {
        let subkey1 = digitP8K1().map{String($0)}
        let EP8bit = back_IP_LR1().EP8bit
        var XorK2_8bit : [String] = [] //EP작업후 키1과 xor연산 8비트
        var str : String = ""
        var S0_4bit : [String] = [] // 왼쪽 4비트
        var S1_4bit : [String] = [] // 오른쪽 4비트
        
        for i in 0..<EP8bit.count {
            let temp1 = EP8bit[i].map{String($0)}
            for j in 0..<subkey1.count {
                if temp1[j] == subkey1[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            XorK2_8bit.append(str)
            str = ""
        }
        
        for i in 0..<XorK2_8bit.count{
            var temp2 = XorK2_8bit[i].map{String($0)}
            var left : [String] = []
            for j in 0..<4 {
                left.append(temp2[j])
                if j==3 {
                    for _ in 0..<4 {
                        temp2.removeFirst()
                    }
                    let temp3 = temp2.joined(separator: "")
                    S1_4bit.append(temp3)
                }
            }
            S0_4bit.append(left.joined(separator: ""))
        }
        return (XorK2_8bit, S0_4bit, S1_4bit)
    }
    
    //S0, S1 작업후 합친 4비트
    func back_S01_func1() -> (S01_4bit: Array<String>, P4_4bit: Array<String>) {
        let P4 = [2,4,3,1]
        let s0_4 = back_EP_xor2().S0_4bit
        let s1_4 = back_EP_xor2().S1_4bit
        let S0_4bit = S0_func(with: s0_4)
        let S1_4bit = S1_func(with: s1_4)
        var S01_4bit : [String] = []
        var str = ""
        var P4_4bit : [String] = []
        for i in 0..<s0_4.count {
            S01_4bit.append((S0_4bit[i] + S1_4bit[i]))
        }
    //        return S01_4bit
        for i in 0..<S01_4bit.count {
            let temp = S01_4bit[i].map{String($0)}
            for j in 0..<P4.count {
                str = str + temp[P4[j]-1]
                if j == P4.count - 1 {
                    P4_4bit.append(str)
                    str = ""
                }
            }
        }
        return (S01_4bit, P4_4bit)
    }
    
    //P4작업한 4비트(S01_func1().P4_4bit)
    func back_P4_xor1() -> Array<String> {
        let P4_4bit = back_S01_func1().P4_4bit
        let SWleft4 = back_IP_LR1().SWleft4
        var str = ""
        var P4_XOR : [String] = []
        
        for i in 0..<SWleft4.count {
            let temp1 = P4_4bit[i].map{String($0)}
            let temp2 = SWleft4[i].map{String($0)}
            for j in 0..<temp2.count {
                if temp1[j] == temp2[j] {
                    str = str + "0"
                }
                else {
                    str = str + "1"
                }
            }
            P4_XOR.append(str)
            str = ""
            
        }
        return P4_XOR
    }

    func back_IP_1() -> (str: String, result8bit: Array<String>) {
        let IP_1Key = [4,1,3,5,7,2,8,6]
        let left4 = back_P4_xor1()
        let right4 = back_P4_xor().P4_XOR
        var bit8 : [String] = []
        var str : String = ""
        var str1 = ""
        var result8bit : [String] = []
        
        for i in 0..<left4.count {
            bit8.append((left4[i] + right4[i]))
        }
        
        for i in 0..<bit8.count {
            let temp3 = bit8[i].map{String($0)}
            for j in 0..<IP_1Key.count {
                str1 = str1 + temp3[IP_1Key[j]-1]
                if j == IP_1Key.count - 1 {
                    result8bit.append(str1)
                    str1 = ""
                }
            }
        }
        
        for i in 0..<result8bit.count {
            let temp = Int(result8bit[i],radix: 2)!
            let temp1 = String(Unicode.Scalar(temp)!)
            str = str + temp1
        }
        return (str, result8bit)
    }
    
    
    //암호화 버튼
    @IBAction func buttonBT(_ sender: Any) {
        
        subkey1LB.text = digitP8K1()
        subkey2LB.text = digitP8K2()
        text1.text = IP_1().str
        text2.text = back_IP_1().str
        print("입력된 키(0-1023) = "+digit0())
        print("입력된 평문 = "+enteripTF.text!)

        print("암호화 시작")
        print("P10(3,5,2,7,4,10,1,9,8,6) 작업 = "+digitP10())
        print("LS1L = ",LS1LR().LS1L)
        print("LS1R = ",LS1LR().LS1R)
        print("K1 = "+digitP8K1()+" (8bit)")
        print("K2 = "+digitP8K2()+" (8bit)")
        print("평문 IP(2,6,3,1,4,8,5,7) 작업 = ",sentence())
        print("IP작업 후 왼쪽 4비트들 배열(left4bit) = ",IP_LR().IPleft4)
        print("IP작업 후 오른쪽 4비트 배열(right4bit) = ",IP_LR().IPright4)
        print("EP(4,1,2,3,2,3,4,1) 작업 = ",IP_LR().EP8bit)
        print("E/P ⊕ K1 = ",EP_xor().XorK1_8bit)
        print("S0,S1 4비트 = ",S01_func().S01_4bit)
        print("P4(2,4,3,1) 작업 = ",S01_func().P4_4bit)
        print("P4 ⊕ left4bit = ",P4_xor().P4_XOR)
        print("SW = ",P4_xor().SW_8bit)
        print("IP-1(4,1,3,5,7,2,8,6) 작업 =",IP_1().result8bit)
        print("암호화 문장 = "+IP_1().str)
        print("back_IP-1(4,1,3,5,7,2,8,6) 작업 =",back_IP_1().result8bit)
        print("복호화 문장 = "+back_IP_1().str)

    }
    

    
    //다시입력 버튼
    @IBAction func resetBT(_ sender: Any) {
        enteripTF.text = nil
        enterkeyTF.text = nil
        subkey1LB.text = nil
        subkey2LB.text = nil
        text1.text = nil
        text2.text = nil
        
    }
    
}
